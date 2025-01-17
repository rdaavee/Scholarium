part of 'notification_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class NotificationsInitialEvent extends NotificationsEvent {}

class FetchNotificationsEvent extends NotificationsEvent {}

class UpdateNotificationStatusEvent extends NotificationsEvent {
  final String notificationId;

  const UpdateNotificationStatusEvent(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class AcceptScheduleEvent extends NotificationsEvent {}

class RejectScheduleEvent extends NotificationsEvent {}

class DeleteNotificationEvent extends NotificationsEvent {
  final String notificationId;

  const DeleteNotificationEvent(this.notificationId);
}

class UpdateScheduleStatusEvent extends NotificationsEvent {
  final String scheduleId;

  const UpdateScheduleStatusEvent(this.scheduleId);
}

class NewNotificationEvent extends NotificationsEvent {
  final NotificationsModel notification;

  NewNotificationEvent(this.notification);

  @override
  List<Object> get props => [notification];
}

class DeleteScheduleNotificationEvent extends NotificationsEvent {
  final String scheduleId;
  final String schoolId;

  const DeleteScheduleNotificationEvent(this.scheduleId, this.schoolId);
}
