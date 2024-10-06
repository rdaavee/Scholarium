import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:meta/meta.dart';

part 'announcements_event.dart';
part 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  final GlobalRepositoryImpl _globalRepositoryImpl;
  AnnouncementsBloc(this._globalRepositoryImpl)
      : super(AnnouncementsInitial()) {
    on<AnnouncementInitialEvent>(announcementInitialEvent);
  }

  FutureOr<void> announcementInitialEvent(
      AnnouncementInitialEvent event, Emitter<AnnouncementsState> emit) async {
    emit(AnnouncementLoadingState());
    emit(AnnouncementLoadedSuccessState());
  }
}
