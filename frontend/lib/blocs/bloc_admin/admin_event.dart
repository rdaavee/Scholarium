part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent {}

class AdminInitialEvent extends AdminEvent {}

class FetchDataEvent extends AdminEvent {}

class FetchUsersEvent extends AdminEvent {
  final String? selectedRole;
  final String? statusFilter;

  FetchUsersEvent(this.selectedRole, this.statusFilter);
}

class FetchUsersRoleEvent extends AdminEvent {}

class CreateUserEvent extends AdminEvent {
  final UserModel user;

  CreateUserEvent(this.user);
}

class UpdateUserEvent extends AdminEvent {
  final String schoolId;
  final UserModel user;

  UpdateUserEvent(this.schoolId, this.user);
}

class DeleteUserEvent extends AdminEvent {
  final String schoolId;

  DeleteUserEvent(this.schoolId);
}

class FetchAnnouncementsEvent extends AdminEvent {}

class CreateAnnouncementEvent extends AdminEvent {
  final AnnouncementModel announcement;

  // Add a constructor to initialize 'announcement'
  CreateAnnouncementEvent(this.announcement);
}

class UpdateAnnouncementEvent extends AdminEvent {
  final String schoolID;
  final AnnouncementModel announcement;

  UpdateAnnouncementEvent(this.schoolID, this.announcement);
}

class DeleteAnnouncementEvent extends AdminEvent {
  final String id;

  DeleteAnnouncementEvent(this.id);
}
