import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GlobalRepositoryImpl _globalService;

  NotificationsBloc(this._globalService) : super(NotificationsInitial()) {
    on<NotificationsInitialEvent>(notificationsInitialEvent);
    on<FetchNotificationsEvent>(onFetchNotificationsEvent);
    on<UpdateNotificationStatusEvent>(onUpdateNotificationsEvent);
  }

  FutureOr<void> notificationsInitialEvent(
      NotificationsInitialEvent event, Emitter<NotificationsState> emit) async {
    emit(NotificationsLoadingState());
    emit(NotificationsLoadedSuccessState(notifications: const [], users: []));
  }

  FutureOr<void> onFetchNotificationsEvent(
      FetchNotificationsEvent event, Emitter<NotificationsState> emit) async {
    try {
      emit(NotificationsLoadingState());
      List<NotificationsModel> notifications =
          await _globalService.fetchNotificationsData();
      UserModel user =
          await _globalService.fetchUserProfile();
      emit(NotificationsLoadedSuccessState(notifications: notifications, users: [user]));
    } catch (e) {
      emit(NotificationsErrorState(message: e.toString()));
    }
  }

  FutureOr<void> onUpdateNotificationsEvent(UpdateNotificationStatusEvent event,
      Emitter<NotificationsState> emit) async {
    try {
      await _globalService.updateNotificationStatus(event.notificationId);
      add(FetchNotificationsEvent());
    } catch (e) {
      emit(NotificationsErrorState(
          message: 'Failed to update notification status: $e'));
    }
  }
}
