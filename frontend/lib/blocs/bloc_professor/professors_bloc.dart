import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'professors_event.dart';
part 'professors_state.dart';

class ProfessorsBloc extends Bloc<ProfessorsEvent, ProfessorsState> {
  ProfessorsBloc() : super(ProfessorsInitialState()) {
    on<ProfessorsInitialEvent>(professorsInitialEvent);
  }

  FutureOr<void> professorsInitialEvent(
      ProfessorsInitialEvent event, Emitter<ProfessorsState> emit) async {
    emit(ProfessorsLoadingState());
    emit(ProfessorsLoadingState());
    emit(ProfessorsLoadedSuccessState());
  }
}
