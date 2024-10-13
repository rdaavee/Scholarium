import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'announcements_event.dart';
part 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  AnnouncementsBloc() : super(AnnouncementsInitial()) {
    on<AnnouncementInitialEvent>(announcementInitialEvent);
  }

  FutureOr<void> announcementInitialEvent(
      AnnouncementInitialEvent event, Emitter<AnnouncementsState> emit) async {
    emit(AnnouncementLoadingState());
    emit(AnnouncementLoadedSuccessState());
  }
}
