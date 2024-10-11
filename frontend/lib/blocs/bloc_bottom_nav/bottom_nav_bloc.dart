import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  final GlobalRepositoryImpl _globalService;

  BottomNavBloc(this._globalService) : super(BottomNavInitialState()) {
    on<BottomNavInitialEvent>(_onInitialEvent);
    on<FetchUnreadCountEvent>(_fetchUnreadCount);
    on<BottomNavItemSelected>(_onItemTapped);
  }

  FutureOr<void> _onInitialEvent(
      BottomNavInitialEvent event, Emitter<BottomNavState> emit) async {
    emit(BottomNavLoadingState());

    try {
      final unreadCount = await _globalService.fetchUnreadNotificationCount();
      emit(BottomNavLoadedSuccessState(unreadCount: unreadCount, selectedIndex: 0));
    } catch (e) {
      print("Error fetching unread count: $e");
      emit(BottomNavLoadedSuccessState(unreadCount: 0, selectedIndex: 0)); 
    }
  }

  FutureOr<void> _onItemTapped(
      BottomNavItemSelected event, Emitter<BottomNavState> emit) async {
    final currentState = state;

    if (currentState is BottomNavLoadedSuccessState) {
      emit(BottomNavLoadedSuccessState(
        unreadCount: currentState.unreadCount,
        selectedIndex: event.index,
      ));
    }
  }


  FutureOr<void> _fetchUnreadCount(
      FetchUnreadCountEvent event, Emitter<BottomNavState> emit) async {
    try {
      final unreadCount = await _globalService.fetchUnreadNotificationCount();

      final currentState = state;
      if (currentState is BottomNavLoadedSuccessState) {
        emit(BottomNavLoadedSuccessState(
          unreadCount: unreadCount,
          selectedIndex: currentState.selectedIndex,
        ));
      }
    } catch (e) {
      print("Error fetching unread messages: $e");
    }
  }
}
