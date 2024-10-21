import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GlobalRepositoryImpl _globalRepository;
  final StudentRepositoryImpl _studentRepository;

  NotificationsBloc(this._globalRepository, this._studentRepository)
      : super(NotificationsLoadingState()) {
    on<FetchNotificationsEvent>(fetchNotificationsEvent);
    on<UpdateNotificationStatusEvent>(updateNotificationsEvent);
    on<UpdateScheduleStatusEvent>(updateScheduleEvent);
    on<DeleteScheduleNotificationEvent>(deleteScheduleNotificationEvent);
    on<DeleteNotificationEvent>(deleteNotificationEvent);
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

  FutureOr<void> updateNotificationsEvent(UpdateNotificationStatusEvent event,
      Emitter<NotificationsState> emit) async {
    try {
      await _globalRepository.updateNotificationStatus(event.notificationId);
      add(FetchNotificationsEvent());
    } catch (e) {
      emit(NotificationsErrorState(
          message: 'Failed to update notification status: $e'));
    }
  }

  FutureOr<void> deleteNotificationEvent(
      DeleteNotificationEvent event, Emitter<NotificationsState> emit) async {
    try {
      await _globalRepository.deleteNotification(event.notificationId);
      add(FetchNotificationsEvent());
    } catch (e) {
      emit(NotificationsErrorState(
          message: 'Failed to delete notification: $e'));
    }
  }

  FutureOr<void> updateScheduleEvent(
      UpdateScheduleStatusEvent event, Emitter<NotificationsState> emit) async {
    try {
      await _studentRepository.confirmSchedule(scheduleId: event.scheduleId);
      add(FetchNotificationsEvent());
    } catch (e) {
      emit(NotificationsErrorState(
          message: 'Failed to update schedule status: $e'));
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
