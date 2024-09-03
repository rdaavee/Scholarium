import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_bloc.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_event.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_state.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/schedule_header.dart';
import '../../widgets/timeline_item.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late ScheduleBloc scheduleBloc;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService();
    scheduleBloc = ScheduleBloc(apiService);
    _initialize();
  }

  Future<void> _initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    scheduleBloc.add(LoadScheduleEvent(token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: Column(
        children: [
          ScheduleHeader(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F3F4),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: BlocBuilder<ScheduleBloc, ScheduleState>(
                bloc: scheduleBloc,
                builder: (context, state) {
                  if (state is ScheduleLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ScheduleLoadedSuccess) {
                    final duties = state.schedule;

                    if (duties.isEmpty) {
                      return const Center(
                        child: Text('No schedules available'),
                      );
                    }

                    return ListView.builder(
                      itemCount: duties.length,
                      itemBuilder: (context, index) {
                        final duty = Map<String, dynamic>.from(duties[index]);
                        final isCompleted = duty['completed'] ==
                            'true'; // Map 'completed' value to boolean

                        return TimelineItem(
                          duty: duty,
                          color: isCompleted ? Colors.green : Colors.grey,
                        );
                      },
                    );
                  } else if (state is ScheduleErrorState) {
                    return Center(
                      child: Text('Failed to load schedule: ${state.message}'),
                    );
                  } else {
                    return const Center(
                      child: Text('Unexpected state!'),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
