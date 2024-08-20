part of 'bottom_nav_bloc.dart';

@immutable
abstract class BottomNavEvent {}

class BottomNavItemSelected extends BottomNavEvent {
  final int index;
  BottomNavItemSelected(this.index);
}
