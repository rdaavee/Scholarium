part of 'bottom_nav_bloc.dart';

@immutable
abstract class BottomNavState {}

class BottomNavInitialState extends BottomNavState {}

class BottomNavItemSelectedState extends BottomNavState {
  final int selectedIndex;
  BottomNavItemSelectedState(this.selectedIndex);
}
