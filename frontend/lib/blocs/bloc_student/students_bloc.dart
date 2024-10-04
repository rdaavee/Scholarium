import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:isHKolarium/api/models/schedule_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final StudentRepositoryImpl _studentRepositoryImpl;
  final GlobalRepositoryImpl _globalRepositoryImpl;

  StudentsBloc(this._studentRepositoryImpl, this._globalRepositoryImpl) : super(StudentsInitial()) {
    on<StudentsInitialEvent>(studentInitialEvents);
    on<FetchUserEvent>(_onFetchUserEvent);
    on<FetchAnnouncementEvent>(_onFetchAnnoucementEvent);
    on<FetchLatestEvent>(_onFetchLatestEvent);
  }

  Future<void> studentInitialEvents(
      StudentsInitialEvent event, Emitter<StudentsState> emit) async {
    emit(StudentsLoadingState());
    emit(
      StudentsLoadedSuccessState(
          users: const [],
          todaySchedule: const [],
          nextSchedule: const [],
          announcements: const [],
          hours: const []),
    );
  }

  FutureOr<void> _onFetchUserEvent(
      FetchUserEvent event, Emitter<StudentsState> emit) async {
    try {
      UserModel user = await _studentRepositoryImpl.fetchUserData();
      final scheduleData = await _studentRepositoryImpl.fetchUpcomingSchedule();
      AnnouncementModel latestAnnouncement =
          await _globalRepositoryImpl.fetchLatestAnnouncementData();
      DtrHoursModel totalhours =
          await _studentRepositoryImpl.fetchDtrTotalHoursData();

      emit(StudentsLoadedSuccessState(
        users: [user],
        todaySchedule: scheduleData['today'],
        nextSchedule: [scheduleData['next']],
        announcements: [latestAnnouncement],
        hours: [totalhours],
      ));
    } catch (error) {
      print('Error fetching user data: $error');
      emit(StudentsErrorState(message: error.toString()));
    }
  }

  Future<void> _onFetchAnnoucementEvent(
      FetchAnnouncementEvent event, Emitter<StudentsState> emit) async {
    try {
      UserModel user = await _studentRepositoryImpl.fetchUserData();
      final scheduleData = await _studentRepositoryImpl.fetchUpcomingSchedule();
      List<AnnouncementModel> announcements =
          await _globalRepositoryImpl.fetchAnnoucementData();
      DtrHoursModel totalhours =
          await _studentRepositoryImpl.fetchDtrTotalHoursData();

      emit(StudentsLoadedSuccessState(
        users: [user],
        todaySchedule: scheduleData['today'],
        nextSchedule: [scheduleData['next']],
        announcements: announcements,
        hours: [totalhours],
      ));
    } catch (e) {
      print('Error fetching announcements: $e');
      emit(StudentsErrorState(message: e.toString()));
    }
  }

  Future<void> _onFetchLatestEvent(
      FetchLatestEvent event, Emitter<StudentsState> emit) async {
    try {
      UserModel user = await _studentRepositoryImpl.fetchUserData();
      final scheduleData = await _studentRepositoryImpl.fetchUpcomingSchedule();
      AnnouncementModel latestAnnouncement =
          await _globalRepositoryImpl.fetchLatestAnnouncementData();
      DtrHoursModel totalhours =
          await _studentRepositoryImpl.fetchDtrTotalHoursData();
      emit(StudentsLoadedSuccessState(
        users: [user],
        todaySchedule: scheduleData['today'],
        nextSchedule: [scheduleData['next']],
        announcements: [latestAnnouncement],
        hours: [totalhours],
      ));
    } catch (error) {
      print('Error fetching latest announcement: $error');
      emit(StudentsErrorState(message: error.toString()));
    }
  }
}
