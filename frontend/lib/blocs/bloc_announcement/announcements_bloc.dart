import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'announcements_event.dart';
part 'announcements_state.dart';

class AnnouncementsBloc extends Bloc<AnnouncementsEvent, AnnouncementsState> {
  AnnouncementsBloc() : super(AnnouncementsInitial()) {
    on<AnnouncementsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
