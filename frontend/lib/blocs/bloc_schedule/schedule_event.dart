import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class ScheduleInitialEvent extends ScheduleEvent {}
class LoadUpcomingScheduleEvent extends ScheduleEvent {
  final String token;

  LoadUpcomingScheduleEvent(this.token);
}

class LoadScheduleEvent extends ScheduleEvent {
  final String token;

  LoadScheduleEvent({required this.token});

  @override
  List<Object> get props => [token];
}
