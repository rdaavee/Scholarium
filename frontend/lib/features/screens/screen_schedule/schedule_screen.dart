import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/professor_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_bloc.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_event.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_state.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/no_data.dart';
import 'package:isHKolarium/features/widgets/professor_widgets/alert_dialog.dart';
import 'package:isHKolarium/features/widgets/student_widgets/schedule_widgets/schedule_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/student_widgets/schedule_widgets/timeline_item.dart';

class ScheduleScreen extends StatefulWidget {
  final String role;
  final bool isAppBarBack;
  const ScheduleScreen(
      {super.key, required this.role, required this.isAppBarBack});
  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  late ScheduleBloc scheduleBloc;
  late BottomNavBloc bottomNavBloc;
  late String currentMonth;
  final ProfessorRepositoryImpl profService = ProfessorRepositoryImpl();

  @override
  void initState() {
    super.initState();
    final apiService = StudentRepositoryImpl();
    final profService = ProfessorRepositoryImpl();
    scheduleBloc = ScheduleBloc(apiService, profService);
    currentMonth = DateFormat('MMMM').format(DateTime.now());
    setState(() {
      selectedMonth = currentMonth;
    });
    _initialize(currentMonth);
    bottomNavBloc = BottomNavBloc(GlobalRepositoryImpl());
    bottomNavBloc.add(FetchUnreadCountEvent());
  }

  Future<void> _initialize(String selectedMonth) async {
    final role = await _getRole();
    String monthNumber = monthMap[selectedMonth] ?? "";
    scheduleBloc.add(
        LoadScheduleEvent(selectedMonth: monthNumber, role: role.toString()));
  }

  Future<String?> _getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  final Map<String, String> monthMap = {
    'January': '01',
    'February': '02',
    'March': '03',
    'April': '04',
    'May': '05',
    'June': '06',
    'July': '07',
    'August': '08',
    'September': '09',
    'October': '10',
    'November': '11',
    'December': '12',
  };

  String selectedMonth = '';
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScheduleBloc>(
          create: (context) => scheduleBloc,
        )
      ],
      child: BlocConsumer<ScheduleBloc, ScheduleState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBarWidget(
                title: "Schedule", isBackButton: widget.isAppBarBack),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: ColorPalette.primary.withOpacity(0.6),
                ),
                Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F3F4),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ScheduleDropdown(
                              selectedMonth: selectedMonth,
                              months: months,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMonth = newValue!;
                                  _initialize(selectedMonth);
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: BlocBuilder<ScheduleBloc, ScheduleState>(
                              bloc: scheduleBloc,
                              builder: (context, state) {
                                if (state is ScheduleLoadingState) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (state
                                    is ScheduleLoadedSuccessState) {
                                  final duties = state.schedule;
                                  if (duties.isEmpty) {
                                    return const Center(
                                      child: Text('No schedules available'),
                                    );
                                  }
                                  return ListView.builder(
                                    itemCount: duties.length,
                                    itemBuilder: (context, index) {
                                      final duty = Map<String, dynamic>.from(
                                          duties[index]);
                                      final isCompleted =
                                          duty['completed'] == 'true';
                                      if (widget.role == "Professor" &&
                                          duty['completed'] == "false") {
                                        return GestureDetector(
                                          onTap: () async {
                                            final result = await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return DialogAlertBox(
                                                    scheduleId: duty['_id'],
                                                    schoolId: duty['user_info']
                                                        ['school_id'],
                                                    date: duty['date'],
                                                    timeIn: duty['time'],
                                                    hkType: duty['user_info']['hk_type'],
                                                    professorName:
                                                        duty['professor'],
                                                    professorSignature: '',
                                                  );
                                                });
                                            if (result == true) {
                                              _initialize(selectedMonth);
                                            }
                                          },
                                          child: TimelineItem(
                                            duty: duty,
                                            roleFuture: _getRole(),
                                            color: isCompleted
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        );
                                      } else {
                                        return TimelineItem(
                                          duty: duty,
                                          roleFuture: _getRole(),
                                          color: isCompleted
                                              ? Colors.green
                                              : Colors.grey,
                                        );
                                      }
                                    },
                                  );
                                } else if (state is ScheduleErrorState) {
                                  return NoData();
                                } else {
                                  return const Scaffold(
                                    body: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
