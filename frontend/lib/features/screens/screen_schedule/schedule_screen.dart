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
import 'package:isHKolarium/features/screens/screen_admin/create_schedule_screen.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';
import 'package:isHKolarium/features/widgets/no_data.dart';
import 'package:isHKolarium/features/widgets/professor_widgets/alert_dialog.dart';
import 'package:isHKolarium/features/widgets/student_widgets/schedule_widgets/schedule_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/student_widgets/schedule_widgets/timeline_item.dart';

class ScheduleScreen extends StatefulWidget {
  final String role;
  final bool isAppBarBack;
  final String? isAdmin;
  final String? schoolID;
  const ScheduleScreen(
      {super.key,
      required this.role,
      required this.isAppBarBack,
      this.schoolID,
      this.isAdmin});
  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  late ScheduleBloc scheduleBloc;
  late BottomNavBloc bottomNavBloc;
  late String currentMonth;
  String? isAdmin;
  String? schoolID;
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
    // context.read<BottomNavBloc>().add(FetchUnreadCountEvent());
  }

  Future<void> _initialize(String selectedMonth) async {
    final role = await _getRole();
    String monthNumber = monthMap[selectedMonth] ?? "";
    isAdmin = widget.isAdmin;
    schoolID = widget.schoolID;

    if (isAdmin.toString() == "Yes") {
      scheduleBloc.add(FetchScheduleFromAdminEvent(
          selectedMonth: monthNumber, schoolID: schoolID.toString()));
    } else {
      scheduleBloc.add(FetchScheduleEvent(
          selectedMonth: monthNumber, role: role.toString()));
    }
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
        ),
        BlocProvider<BottomNavBloc>(
          create: (context) => bottomNavBloc,
        )
      ],
      child: Scaffold(
        appBar:
            AppBarWidget(title: "Schedule", isBackButton: widget.isAppBarBack),
        floatingActionButton: widget.role == "Professor"
            ? FloatingActionButton(
                backgroundColor: ColorPalette.primary.withOpacity(0.6),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SetScheduleScreen(isRole: widget.role,)),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
        body: BlocConsumer<ScheduleBloc, ScheduleState>(
          listener: (context, state) {},
          builder: (context, state) {
            return RefreshIndicator.adaptive(
              onRefresh: () => _initialize(selectedMonth),
              child: Stack(
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
                  Column(
                    children: [
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
                                          child: LoadingCircular());
                                    } else if (state
                                        is ScheduleLoadedSuccessState) {
                                      final duties =
                                          state.schedule.where((duty) {
                                        return duty['isActive'] == true;
                                      }).toList();
                                      if (duties.isEmpty) {
                                        return const Center(
                                            child: NoData(
                                          title: 'No Schedule Available',
                                        ));
                                      }
                                      return ListView.builder(
                                        itemCount: duties.length,
                                        itemBuilder: (context, index) {
                                          final duty =
                                              Map<String, dynamic>.from(
                                                  duties[index]);
                                          final isCompleted =
                                              duty['completed'] == 'true';
                                          if (widget.role == "Student") {
                                            return TimelineItem(
                                              duty: duty,
                                              roleFuture: _getRole(),
                                              color: isCompleted
                                                  ? Colors.green
                                                  : Colors.grey,
                                            );
                                          } else {
                                            return GestureDetector(
                                              onTap: isCompleted
                                                  ? null
                                                  : () async {
                                                      final result =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          print(duty['task']);
                                                          return DialogAlertBox(
                                                            scheduleId:
                                                                duty['_id'],
                                                            role: widget.role,
                                                            selectedMonth:
                                                                selectedMonth,
                                                            schoolId: duty[
                                                                    'user_info']
                                                                ['school_id'],
                                                            date: duty['date'],
                                                            timeIn:
                                                                duty['time_in'],
                                                            timeOut: duty[
                                                                'time_out'],
                                                            remarks:
                                                                duty['task'],
                                                            hkType: duty[
                                                                    'user_info']
                                                                ['hk_type'],
                                                            professorName: duty[
                                                                'professor'],
                                                          );
                                                        },
                                                      );
                                                      if (result == true) {
                                                        _initialize(
                                                            selectedMonth);
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
                                          }
                                        },
                                      );
                                    } else if (state is ScheduleErrorState) {
                                      return NoData(
                                        title: 'No Schedule Available',
                                      );
                                    } else {
                                      return const Scaffold(
                                        body: Center(
                                          child: LoadingCircular(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
