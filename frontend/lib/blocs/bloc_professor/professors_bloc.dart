import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/professor_repository_impl.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/professor_schedule_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'professors_event.dart';
part 'professors_state.dart';

class ProfessorsBloc extends Bloc<ProfessorsEvent, ProfessorsState> {
  final ProfessorRepositoryImpl _professorRepositoryImpl;
  final GlobalRepositoryImpl _globalRepositoryImpl;

  ProfessorsBloc(this._professorRepositoryImpl, this._globalRepositoryImpl)
      : super(ProfessorsLoadingState()) {
    on<ProfessorsInitialEvent>(professorsInitialEvent);
    on<FetchLatestEvent>(fetchLatestEvent);
    on<ProfessorsCreatePostEvent>(createPost);
  }

  FutureOr<void> professorsInitialEvent(
      ProfessorsInitialEvent event, Emitter<ProfessorsState> emit) async {
    emit(ProfessorsLoadingState());
    emit(ProfessorsLoadedSuccessState(
        users: [], announcements: [], schedules: []));
  }

  Future<void> fetchLatestEvent(
      FetchLatestEvent event, Emitter<ProfessorsState> emit) async {
    emit(ProfessorsLoadingState());
    try {
      UserModel user = await _globalRepositoryImpl.fetchUserProfile();
      AnnouncementModel latestAnnouncement =
          await _globalRepositoryImpl.fetchLatestAnnouncementData();
      final prefs = await SharedPreferences.getInstance();
      final schoolId = prefs.getString('schoolID');
      final schedule = await _professorRepositoryImpl
          .fetchProfTodaySchedule(schoolId.toString());
      emit(ProfessorsLoadedSuccessState(
        users: [user],
        announcements: [latestAnnouncement],
        schedules: schedule,
      ));
    } catch (error) {
      print(error);
      emit(ProfessorsErrorState(message: error.toString()));
    }
  }

  Future<void> createPost(
      ProfessorsCreatePostEvent event, Emitter<ProfessorsState> emit) async {
    try {
      final notification = NotificationsModel(
        title: event.title,
        message: event.message,
      );
      await _professorRepositoryImpl.createPost(notification);
      add(FetchLatestEvent());
    } catch (e) {
      emit(PostErrorState());
    }
  }
}
