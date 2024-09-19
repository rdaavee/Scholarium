import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:isHKolarium/api/models/schedule_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final StudentRepositoryImpl _studentRepositoryImpl;

  StudentsBloc(this._studentRepositoryImpl) : super(StudentsInitial()) {
    on<StudentsInitialEvent>(studentInitialEvents);
    on<FetchUserEvent>(fetchUserEvent);
    on<FetchAnnouncementEvent>(fetchAnnoucementEvent);
    on<FetchLatestEvent>(fetchLatestEvent);
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

  FutureOr<void> fetchUserEvent(
      FetchUserEvent event, Emitter<StudentsState> emit) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(token);
      UserModel user = await _studentRepositoryImpl.fetchUserData(token: token);
      final scheduleData = await _studentRepositoryImpl.fetchUpcomingSchedule(token: token.toString());
      AnnouncementModel latestAnnouncement =
          await _studentRepositoryImpl.fetchLatestAnnouncementData();
      DtrHoursModel totalhours =
          await _studentRepositoryImpl.fetchDtrTotalHoursData(token: token);
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

  Future<void> fetchAnnoucementEvent(
      FetchAnnouncementEvent event, Emitter<StudentsState> emit) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      UserModel user = await _studentRepositoryImpl.fetchUserData(token: token);
      final scheduleData = await _studentRepositoryImpl.fetchUpcomingSchedule(token: token.toString());
      List<AnnouncementModel> announcements =
          await _studentRepositoryImpl.fetchAnnoucementData();
      DtrHoursModel totalhours =
          await _studentRepositoryImpl.fetchDtrTotalHoursData(token: token);

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

  Future<void> fetchLatestEvent(
      FetchLatestEvent event, Emitter<StudentsState> emit) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(token);
      UserModel user = await _studentRepositoryImpl.fetchUserData(token: token);
      final scheduleData = await _studentRepositoryImpl.fetchUpcomingSchedule(token: token.toString());
      AnnouncementModel latestAnnouncement =
          await _studentRepositoryImpl.fetchLatestAnnouncementData();
      DtrHoursModel totalhours =
          await _studentRepositoryImpl.fetchDtrTotalHoursData(token: token);
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
