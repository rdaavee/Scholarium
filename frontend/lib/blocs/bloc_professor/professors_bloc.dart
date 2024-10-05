import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:isHKolarium/api/implementations/professor_repository_impl.dart';
import 'package:isHKolarium/api/models/post_model.dart';
import 'package:meta/meta.dart';

part 'professors_event.dart';
part 'professors_state.dart';

class ProfessorsBloc extends Bloc<ProfessorsEvent, ProfessorsState> {
  final ProfessorRepositoryImpl _professorRepositoryImpl;

  ProfessorsBloc(this._professorRepositoryImpl)
      : super(ProfessorsInitialState()) {
    on<ProfessorsInitialEvent>(professorsInitialEvent);
    on<ProfessorsCreatePostEvent>(createPost);
  }

  FutureOr<void> professorsInitialEvent(
      ProfessorsInitialEvent event, Emitter<ProfessorsState> emit) async {
    emit(ProfessorsLoadedSuccessState());
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
}
