part of 'dtr_bloc.dart';

@immutable
abstract class DtrEvent {}

class DtrInitialEvent extends DtrEvent {}
class FetchDtrEvent extends DtrEvent {}

