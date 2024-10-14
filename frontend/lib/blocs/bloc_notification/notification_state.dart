part of 'notification_bloc.dart';

@immutable
abstract class NotificationsState {}

abstract class NotificationsActionState extends NotificationsState {}

class NotificationsLoadingState extends NotificationsState {}
class NotificationsLoadedSuccessState extends NotificationsState {
  final List<NotificationsModel> notifications;
  final List<UserModel> users;
  NotificationsLoadedSuccessState({required this.notifications, required this.users});
}

class NotificationsErrorState extends NotificationsState {
  final String message;

  NotificationsErrorState({required this.message});
}

