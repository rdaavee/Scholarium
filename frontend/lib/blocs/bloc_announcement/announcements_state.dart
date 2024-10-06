part of 'announcements_bloc.dart';

@immutable
abstract class AnnouncementsState {}

final class AnnouncementsInitial extends AnnouncementsState {}

class AnnouncementLoadingState extends AnnouncementsState {}

class AnnouncementLoadedSuccessState extends AnnouncementsState {
  // List<AnnouncementModel> announcement;
}

class AnnouncementErrorState extends AnnouncementsState {
  final String message;

  AnnouncementErrorState({required this.message});
}
