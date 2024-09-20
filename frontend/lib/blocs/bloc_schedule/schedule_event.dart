import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ScheduleInitialEvent extends ScheduleEvent {}

class LoadUpcomingScheduleEvent extends ScheduleEvent {
  final String token;
  final String selectedMonth;

  LoadUpcomingScheduleEvent({
    required this.token,
    required this.selectedMonth,
  });
}

class LoadScheduleEvent extends ScheduleEvent {
  final String token;
  final String selectedMonth;

  LoadScheduleEvent({required this.token, required this.selectedMonth});

  @override
  List<Object> get props => [token, selectedMonth];
}
