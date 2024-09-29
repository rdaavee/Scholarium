import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavInitialState()) {
    on<BottomNavItemSelected>(_onItemTapped);
  }

  void _onItemTapped(
      BottomNavItemSelected event, Emitter<BottomNavState> emit) {
    emit(BottomNavItemSelectedState(event.index));
    print('Selected index: ${event.index}');
  }
}
