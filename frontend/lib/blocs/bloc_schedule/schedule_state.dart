import 'package:equatable/equatable.dart';

abstract class ScheduleState extends Equatable {
  @override
  List<Object> get props => [];
}

class ScheduleLoadingState extends ScheduleState {}

class ScheduleLoadedSuccessState extends ScheduleState {
  final List<Map<String, dynamic>> schedule;

  ScheduleLoadedSuccessState({ required this.schedule,});

  @override
  List<Object> get props => [schedule];
}

class ScheduleErrorState extends ScheduleState {
  final String message;

  ScheduleErrorState(this.message);

  @override
  List<Object> get props => [message];
}
