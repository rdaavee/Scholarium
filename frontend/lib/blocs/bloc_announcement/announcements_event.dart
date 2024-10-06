part of 'announcements_bloc.dart';

@immutable
abstract class AnnouncementsEvent {}
class AnnouncementInitialEvent extends AnnouncementsEvent {}
class FetchAllAnnouncementEvent extends AnnouncementsEvent {}
