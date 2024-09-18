import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_bloc.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_event.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_state.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/student_widgets/schedule_widgets/timeline_item.dart';

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
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay color
          Container(
            color: ColorPalette.primary.withOpacity(0.6),
          ),
          // Main content
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 20.0),
                child: Container(
                  height: 120.0,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Schedule",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: ColorPalette.accentWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F3F4),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
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
                            final duty =
                                Map<String, dynamic>.from(duties[index]);
                            final isCompleted = duty['completed'] == 'true';

                            return TimelineItem(
                              duty: duty,
                              color: isCompleted ? Colors.green : Colors.grey,
                            );
                          },
                        );
                      } else if (state is ScheduleErrorState) {
                        return Center(
                          child:
                              Text('Failed to load schedule: ${state.message}'),
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
        ],
      ),
    );
  }
}
