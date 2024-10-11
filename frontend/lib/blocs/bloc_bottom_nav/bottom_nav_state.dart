part of 'bottom_nav_bloc.dart';

@immutable
abstract class BottomNavState {}

class BottomNavInitialState extends BottomNavState {}

class BottomNavLoadingState extends BottomNavState {}


class BottomNavLoadedSuccessState extends BottomNavState {
  final int unreadCount;
  final int selectedIndex;

  BottomNavLoadedSuccessState({
    required this.unreadCount,
    required this.selectedIndex,
  });
}

