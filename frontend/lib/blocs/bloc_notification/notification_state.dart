part of 'notification_bloc.dart';

@immutable
abstract class NotificationsState {}

abstract class NotificationsActionState extends NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoadingState extends NotificationsState {}

class NotificationsLoadedSuccessState extends NotificationsState {
  final List<NotificationsModel> notifications;
  NotificationsLoadedSuccessState({required this.notifications});
}

class NotificationsErrorState extends NotificationsState {
  final String message;

  NotificationsErrorState({required this.message});
}

