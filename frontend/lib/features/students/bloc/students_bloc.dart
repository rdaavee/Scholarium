import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:meta/meta.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final ApiService _apiService;

  StudentsBloc(this._apiService) : super(StudentsInitial()) {
    on<StudentsInitialEvent>(studentInitialEvents);
    on<FetchAnnouncementEvent>(fetchAnnoucementEvent);
  }

  Future<void> studentInitialEvents(
      StudentsInitialEvent event, Emitter<StudentsState> emit) async {
    emit(StudentsLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    emit(StudentsLoadedSuccessState(announcements: []));
  }

  Future<void> fetchAnnoucementEvent(
      FetchAnnouncementEvent event, Emitter<StudentsState> emit) async {
    emit(StudentsLoadingState());

    try {
      List<AnnouncementModel> announcements =
          await _apiService.fetchAnnoucementData();
      print('Fetched announcements: $announcements'); 
      emit(StudentsLoadedSuccessState(announcements: announcements));
    } catch (e) {
      print('Error fetching announcements: $e'); 
      emit(StudentsErrorState(message: e.toString()));
    }
  }
}
