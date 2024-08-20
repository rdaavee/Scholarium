import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  StudentsBloc() : super(StudentsInitial()) {
    on<StudentInitialEvent>(studentInitialEvents);
  }
  Future<void> studentInitialEvents(
      StudentInitialEvent event, Emitter<StudentsState> emit) async {
    emit(StudentsLoadingState());
    await Future.delayed(Duration(seconds: 2));
    emit(StudentLoadedSuccessState());
  }
}
