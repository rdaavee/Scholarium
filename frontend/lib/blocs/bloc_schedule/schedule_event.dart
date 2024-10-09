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
  final String selectedMonth;
  final String role;

  LoadScheduleEvent({required this.selectedMonth, required this.role});

  @override
  List<Object> get props => [selectedMonth];
}

class UpdateDutySchedule extends ScheduleEvent {
  final String id;

  UpdateDutySchedule({required this.id});

  @override
  List<Object> get props => [id];
}
