import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavInitial()) {
    on<BottomNavItemSelected>(_onItemTapped);
  }

  void _onItemTapped(
      BottomNavItemSelected event, Emitter<BottomNavState> emit) {
    if (state is! BottomNavItemSelectedState ||
        (state as BottomNavItemSelectedState).selectedIndex != event.index) {
      emit(BottomNavItemSelectedState(event.index));
      print(event.index);
    }
  }
}