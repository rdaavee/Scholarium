part of 'notification_bloc.dart';

@immutable
abstract class NotificationsEvent {}

class NotificationsInitialEvent extends NotificationsEvent {}
class FetchNotificationsEvent extends NotificationsEvent {}
