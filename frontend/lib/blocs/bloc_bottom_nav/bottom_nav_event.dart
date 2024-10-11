part of 'bottom_nav_bloc.dart';

@immutable
abstract class BottomNavEvent {}

class BottomNavInitialEvent extends BottomNavEvent {}
class FetchUnreadCountEvent extends BottomNavEvent {}
class BottomNavItemSelected extends BottomNavEvent {
  final int index;
  BottomNavItemSelected(this.index);
}
