import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';

part 'dtr_event.dart';
part 'dtr_state.dart';

class DtrBloc extends Bloc<DtrEvent, DtrState> {
  final StudentRepositoryImpl _apiService;

  DtrBloc(this._apiService) : super(DtrInitialState()) {
    on<DtrInitialEvent>(dtrInitialEvent);
    on<FetchDtrEvent>(fetchDtrEvent);
  }

  FutureOr<void> dtrInitialEvent(
      DtrInitialEvent event, Emitter<DtrState> emit) async {
    emit(DtrLoadingState());
    emit(DtrLoadedSuccessState(hours: const [], dtr: const []));
  }

  FutureOr<void> fetchDtrEvent(
      FetchDtrEvent event, Emitter<DtrState> emit) async {
    try {
      DtrHoursModel totalhours = await _apiService.fetchDtrTotalHoursData();
      List<DtrModel> dtr = await _apiService.fetchDtrData();
      emit(DtrLoadedSuccessState(hours: [totalhours], dtr: dtr));
    } catch (error) {
      print('Error fetching DTR: $error');
      emit(DtrErrorState(message: error.toString()));
    }
  }
}
