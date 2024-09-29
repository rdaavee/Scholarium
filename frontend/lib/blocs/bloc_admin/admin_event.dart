part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent {}

class AdminInitialEvent extends AdminEvent {}

class FetchDataEvent extends AdminEvent {}

