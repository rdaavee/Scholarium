import 'package:isHKolarium/api/models/dtr_model.dart';

abstract class ScheduleEvent {}

class FetchScheduleEvent extends ScheduleEvent {
  final String selectedMonth;
  final String role;

  FetchScheduleEvent({required this.selectedMonth, required this.role});
}

class UpdateDutySchedule extends ScheduleEvent {
  final String id;
  final String selectedMonth;
  final String role;

  UpdateDutySchedule({
    required this.id,
    required this.selectedMonth,
    required this.role,
  });
}

class CreateDTREvent extends ScheduleEvent {
  final DtrModel dtr;
  final String selectedMonth;
  final String role;

  CreateDTREvent(
      {required this.dtr, required this.selectedMonth, required this.role});
}
