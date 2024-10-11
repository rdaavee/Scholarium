import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/professor_repository_impl.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/post_model.dart';
import 'package:isHKolarium/api/models/professor_schedule_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'professors_event.dart';
part 'professors_state.dart';

class ProfessorsBloc extends Bloc<ProfessorsEvent, ProfessorsState> {
  final ProfessorRepositoryImpl _professorRepositoryImpl;
  final GlobalRepositoryImpl _globalRepositoryImpl;

  ProfessorsBloc(this._professorRepositoryImpl, this._globalRepositoryImpl)
      : super(ProfessorsInitialState()) {
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

  Future<void> createPost(
      ProfessorsCreatePostEvent event, Emitter<ProfessorsState> emit) async {
    try {
      print("running");
      final post = PostModel(
        title: event.title,
        body: event.body,
        date: DateTime.now(),
        time: DateTime.now().toIso8601String(),
        status: 'Active',
        schoolId: '',
        profId: '',
      );
      await _professorRepositoryImpl.createPost(post);
    } catch (e) {
      print('Error creating post: $e');
      emit(PostErrorState());
    }
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
      final schedule =
          await _professorRepositoryImpl.fetchProfTodaySchedule(schoolId.toString());
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
}
