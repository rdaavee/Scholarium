part of 'dtr_bloc.dart';

@immutable
abstract class DtrState {}

abstract class DtrActionState extends DtrState {}

class DtrInitialState extends DtrState {}

class DtrLoadingState extends DtrState {}

class DtrLoadedSuccessState extends DtrState {
  final List<DtrHoursModel> hours;
  final List<DtrModel> dtr;
  DtrLoadedSuccessState({required this.hours, required this.dtr});
}

class DtrErrorState extends DtrState {
  final String message;

  DtrErrorState({required this.message});
}
