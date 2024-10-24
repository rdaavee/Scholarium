import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/socket/socket_service.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GlobalRepositoryImpl _globalRepository;
  final StudentRepositoryImpl _studentRepository;
  final SocketService _socketService;

  NotificationsBloc(
      this._globalRepository, this._studentRepository, this._socketService)
      : super(NotificationsLoadingState()) {
    on<FetchNotificationsEvent>(fetchNotificationsEvent);
    on<UpdateNotificationStatusEvent>(updateNotificationsEvent);
    on<NewNotificationEvent>(handleNewNotificationEvent);
    on<UpdateScheduleStatusEvent>(updateScheduleEvent);
    on<DeleteScheduleNotificationEvent>(deleteScheduleNotificationEvent);
    on<DeleteNotificationEvent>(deleteNotificationEvent);

    _socketService.messages.listen((message) {
      try {
        NotificationsModel notification = NotificationsModel.fromJson(message);
        add(NewNotificationEvent(notification));
      } catch (e) {
        print('Error parsing notification: $e');
      }
    });
  }

  FutureOr<void> fetchNotificationsEvent(
      FetchNotificationsEvent event, Emitter<NotificationsState> emit) async {
    try {
      emit(NotificationsLoadingState());
      List<NotificationsModel> notifications =
          await _globalRepository.fetchNotificationsData();
      UserModel user = await _globalRepository.fetchUserProfile();
      emit(NotificationsLoadedSuccessState(
          notifications: notifications, users: [user]));
    } catch (e) {
      emit(NotificationsErrorState(message: e.toString()));
    }
  }

  FutureOr<void> updateScheduleEvent(
      UpdateScheduleStatusEvent event, Emitter<NotificationsState> emit) async {
    try {
      await _studentRepository.confirmSchedule(scheduleId: event.scheduleId);

      if (state is NotificationsLoadedSuccessState) {
        final currentState = state as NotificationsLoadedSuccessState;

        final updatedNotifications =
            currentState.notifications.map((notification) {
          if (notification.scheduleId == event.scheduleId) {
            return notification.copyWith(status: true);
          }
          return notification;
        }).toList();

        emit(NotificationsLoadedSuccessState(
            notifications: updatedNotifications, users: currentState.users));
      }
    } catch (e) {
      emit(NotificationsErrorState(
          message: 'Failed to update schedule status: $e'));
    }
  }

  FutureOr<void> updateNotificationsEvent(UpdateNotificationStatusEvent event,
      Emitter<NotificationsState> emit) async {
    try {
      await _globalRepository.updateNotificationStatus(event.notificationId);

      if (state is NotificationsLoadedSuccessState) {
        final currentState = state as NotificationsLoadedSuccessState;

        final updatedNotifications =
            currentState.notifications.map((notification) {
          if (notification.id == event.notificationId) {
            return notification.copyWith(status: true);
          }
          return notification;
        }).toList();

        emit(NotificationsLoadedSuccessState(
            notifications: updatedNotifications, users: currentState.users));
      }
    } catch (e) {
      emit(NotificationsErrorState(
          message: 'Failed to update notification status: $e'));
    }
  }

  FutureOr<void> deleteNotificationEvent(
      DeleteNotificationEvent event, Emitter<NotificationsState> emit) async {
    try {
      await _globalRepository.deleteNotification(event.notificationId);

      if (state is NotificationsLoadedSuccessState) {
        final currentState = state as NotificationsLoadedSuccessState;

        final updatedNotifications = currentState.notifications
            .where((notification) => notification.id != event.notificationId)
            .toList();

        emit(NotificationsLoadedSuccessState(
            notifications: updatedNotifications, users: currentState.users));
      }
    } catch (e) {
      emit(NotificationsErrorState(
          message: 'Failed to delete notification: $e'));
    }
  }

  FutureOr<void> handleNewNotificationEvent(
      NewNotificationEvent event, Emitter<NotificationsState> emit) {
    if (state is NotificationsLoadedSuccessState) {
      final currentState = state as NotificationsLoadedSuccessState;
      final updatedNotifications =
          List<NotificationsModel>.from(currentState.notifications)
            ..insert(0, event.notification);

      emit(NotificationsLoadedSuccessState(
          notifications: updatedNotifications, users: currentState.users));
    }
  }

  FutureOr<void> deleteScheduleNotificationEvent(
      DeleteScheduleNotificationEvent event,
      Emitter<NotificationsState> emit) async {
    try {
      await _globalRepository.deleteNotificationAndScheduleStatus(
          event.scheduleId, event.schoolId);
      add(FetchNotificationsEvent());
    } catch (e) {
      emit(NotificationsErrorState(
          message: 'Failed to delete schedule and notification: $e'));
    }
  }
}
