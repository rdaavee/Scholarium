import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_event/events_bloc.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/event_widgets/events_card.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late EventsBloc eventsBloc;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final globalRepositoryImpl = GlobalRepositoryImpl();
    eventsBloc = EventsBloc(globalRepositoryImpl);
    eventsBloc.add(FetchEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Events", isBackButton: true),
      backgroundColor: Color(0xFFF0F3F4),
      body: BlocConsumer<EventsBloc, EventsState>(
        bloc: eventsBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is EventsLoadedState) {
            final events = state.events;
            return Column(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height - 100.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F3F4),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return EventsCard(
                              event: event,
                              cardColor: Colors.blue,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
            );
          } else {
            return const Center(child: LoadingCircular());
          }
        },
      ),
    );
  }
}
