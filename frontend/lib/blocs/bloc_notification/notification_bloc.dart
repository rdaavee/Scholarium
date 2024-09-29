import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
part 'notification_event.dart';
part 'notification_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GlobalRepositoryImpl _apiService;
  NotificationsBloc(this._apiService) : super(NotificationsInitial()) {
    on<NotificationsInitialEvent>(notificationsInitialEvent);
    on<FetchNotificationsEvent>(fetchNotificationsEvent);
  }

  FutureOr<void> notificationsInitialEvent(
      NotificationsInitialEvent event, Emitter<NotificationsState> emit) async {
    emit(NotificationsLoadingState());
    emit(NotificationsLoadedSuccessState(notifications: const []));
  }

  FutureOr<void> fetchNotificationsEvent(
      FetchNotificationsEvent event, Emitter<NotificationsState> emit) async {
    try {

      List<NotificationsModel> notifications =
          await _apiService.fetchNotificationsData();

      emit(NotificationsLoadedSuccessState(
        notifications: notifications,
      ));
    } catch (e) {
      print('Error fetching notifications: $e');
      emit(NotificationsErrorState(message: e.toString()));
    }
  }
}
