import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dtr_event.dart';
part 'dtr_state.dart';

class DtrBloc extends Bloc<DtrEvent, DtrState> {
  DtrBloc() : super(DtrInitial()) {
    on<DtrEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
