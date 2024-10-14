part of 'announcements_bloc.dart';

@immutable
abstract class AnnouncementsState {}

class AnnouncementLoadingState extends AnnouncementsState {}
class AnnouncementLoadedSuccessState extends AnnouncementsState {}
class AnnouncementErrorState extends AnnouncementsState {
  final String message;
  AnnouncementErrorState({required this.message});
}
