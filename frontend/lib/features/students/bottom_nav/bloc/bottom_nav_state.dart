part of 'bottom_nav_bloc.dart';

@immutable
abstract class BottomNavState {}

class BottomNavInitial extends BottomNavState {}

class BottomNavItemSelectedState extends BottomNavState {
  final int selectedIndex;
  BottomNavItemSelectedState(this.selectedIndex);
}
