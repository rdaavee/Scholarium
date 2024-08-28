import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final ApiService _apiService;

  StudentsBloc(this._apiService) : super(StudentsInitial()) {
    on<StudentsInitialEvent>(studentInitialEvents);
    on<FetchAllEvent>(fetchAllEvent);
    on<FetchLatestEvent>(fetchLatestEvent);
  }

  Future<void> studentInitialEvents(
      StudentsInitialEvent event, Emitter<StudentsState> emit) async {
    emit(StudentsLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    emit(
      StudentsLoadedSuccessState(announcements: const [], hours: const []),
    );
  }

  Future<void> fetchAllEvent(
      FetchAllEvent event, Emitter<StudentsState> emit) async {
    emit(StudentsLoadingState());

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
  
      List<AnnouncementModel> announcements = await _apiService.fetchAnnoucementData();
      DtrHoursModel totalhours = await _apiService.fetchDtrTotalHoursData(token: token);
      
      emit(StudentsLoadedSuccessState(
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
    emit(StudentsLoadingState());

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(token);
      AnnouncementModel latestAnnouncement =
          await _apiService.fetchLatestAnnoucementData();
      DtrHoursModel totalhours =
          await _apiService.fetchDtrTotalHoursData(token: token);
      emit(StudentsLoadedSuccessState(
        announcements: [latestAnnouncement],
        hours: [totalhours],
      ));
    } catch (e) {
      print('Error fetching latest announcement: $e');
      emit(StudentsErrorState(message: e.toString()));
    }
  }
}
