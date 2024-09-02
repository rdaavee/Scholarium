import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'professors_event.dart';
part 'professors_state.dart';

class ProfessorsBloc extends Bloc<ProfessorsEvent, ProfessorsState> {
  ProfessorsBloc() : super(ProfessorsInitial()) {
    on<ProfessorsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
