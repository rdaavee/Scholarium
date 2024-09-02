import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dtr_event.dart';
part 'dtr_state.dart';

class DtrBloc extends Bloc<DtrEvent, DtrState> {
  final ApiService _apiService;

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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      DtrHoursModel totalhours = await _apiService.fetchDtrTotalHoursData(token: token);
      List<DtrModel> dtr = await _apiService.fetchDtrData(token: token);
      emit(DtrLoadedSuccessState(hours: [totalhours], dtr: dtr));
    } catch (error) {
        print('Error fetching dtr: $error');
        emit(DtrErrorState(message: error.toString()));
    }
  }
}
