import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_bloc.dart';
import 'package:isHKolarium/blocs/bloc_student/students_bloc.dart';
import 'package:isHKolarium/config/assets/app_images.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_announcement/announcement.dart';
import 'package:isHKolarium/features/screens/screen_dtr/dtr_screen.dart';
import 'package:isHKolarium/features/screens/screen_event/events_screen.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/school_id_textfield.dart';
import 'package:isHKolarium/features/widgets/label_text_widget.dart';
import 'package:isHKolarium/features/widgets/student_widgets/announcement_widgets/announcement_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/dtr_hours_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/event_widgets/events_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/schedule_widgets/schedule_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/shimmer_widgets/student_shimmer.dart';
import 'package:isHKolarium/features/widgets/view_all_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  late StudentsBloc studentBloc;
  late BottomNavBloc bottomNavBloc;
  late ScheduleBloc scheduleBloc;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final studentRepositoryImpl = StudentRepositoryImpl();
    final globalRepositoryImpl = GlobalRepositoryImpl();
    studentBloc = StudentsBloc(studentRepositoryImpl, globalRepositoryImpl);
    final prefs = await SharedPreferences.getInstance();
    final schoolId = prefs.getString('schoolID');
    studentBloc.add(FetchLatestEvent(schoolId: schoolId.toString()));
    bottomNavBloc = BottomNavBloc(globalRepositoryImpl);
    context.read<BottomNavBloc>().add(FetchUnreadCountEvent());
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final String formattedDate =
        '${months[parsedDate.month - 1]}. ${parsedDate.day}, ${parsedDate.year}';
    return formattedDate;
  }

    String _formatTime(String time) {
    final DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('h:mm a').format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StudentsBloc>(
          create: (context) => studentBloc,
        ),
        BlocProvider<BottomNavBloc>(
          create: (context) => bottomNavBloc,
        ),
      ],
      child: BlocConsumer<StudentsBloc, StudentsState>(
        listener: (context, state) {
          if (state is StudentsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is StudentsLoadingState) {
            return Scaffold(
              body: const StudentShimmer(),
            );
          } else if (state is StudentsLoadedSuccessState) {
            return Scaffold(
              appBar: AppBarWidget(
                  title: "Hello, ${state.users[0].firstName}!",
                  isBackButton: false),
              body: RefreshIndicator.adaptive(
                onRefresh: () => _initialize(),
                child: Stack(
                  children: [
                    Container(
                      color: ColorPalette.primary.withOpacity(0.6),
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF0F3F4),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView(
                                children: [
                                  const SizedBox(
                                    height: 45,
                                  ),
                                  // Upcoming Duties Section
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const LabelTextWidget(
                                            title: "Upcoming Duties"),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ScheduleCard(
                                          scheduleDate: Text(
                                            state.todaySchedule[0].isActive ==
                                                    true
                                                ? _formatDate(state
                                                    .todaySchedule[0].date
                                                    .toString())
                                                : "No Schedule Today",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: ColorPalette.accentBlack,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          scheduleTime: Text(
                                            state.todaySchedule[0].isActive ==
                                                    true
                                                // ? _formatTime(
                                                //         "${state.todaySchedule[0].timeIn}:00")
                                                //     .toString()
                                                // : "",
                                                ? ("${state.todaySchedule[0].timeIn}")
                                                    .toString()
                                                : "",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          roomName: Text(
                                            state.todaySchedule[0].isActive ==
                                                    true
                                                ? state.todaySchedule[0].room
                                                    .toString()
                                                : "",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          cardColor: Colors.white,
                                          imageUrl: AppImages.boyDutyImg,
                                        ),
                                        const SizedBox(width: 5),
                                        ScheduleCard(
                                          scheduleDate: Text(
                                            state.nextSchedule[0].isActive ==
                                                    true
                                                ? _formatDate(state
                                                    .nextSchedule[0].date
                                                    .toString())
                                                : "No Upcomming Schedule",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          scheduleTime: Text(
                                            state.nextSchedule[0].isActive ==
                                                    true
                                                // ? _formatTime(
                                                //         "${state.nextSchedule[0].timeIn}:00")
                                                //     .toString()
                                                // : "",
                                                ? ("${state.nextSchedule[0].timeIn}")
                                                    .toString()
                                                : "",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          roomName: Text(
                                            state.nextSchedule[0].isActive ==
                                                    true
                                                ? state.nextSchedule[0].room
                                                    .toString()
                                                : "",
                                            style: const TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          cardColor: Colors.white,
                                          imageUrl: AppImages.boyDutyImg,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Your DTR Section
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const LabelTextWidget(
                                            title: "Your DTR"),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DtrScreen(
                                                  user: state.users[0],
                                                ),
                                              ),
                                            );
                                          },
                                          child: const ViewAllText(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DtrHoursCard(
                                    progress: (state.hours[0].totalhours /
                                            state.hours[0].targethours)
                                        .clamp(0.0, 1.0),
                                    cardColor: Colors.white,
                                  ),
                                  // Announcements Section
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const LabelTextWidget(
                                            title: "Announcements"),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const AnnouncementsScreen(
                                                        isBackButtonTrue: true),
                                              ),
                                            );
                                          },
                                          child: const ViewAllText(),
                                        ),
                                      ],
                                    ),
                                  ),

                                  AnnouncementCard(
                                    textLabel: Text(
                                      state.announcements[0].title.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6D7278),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    textBody: Text(
                                      state.announcements[0].body.toString(),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFC1C1C1),
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    date: Text(
                                      state.announcements[0].date.toString(),
                                      style: const TextStyle(
                                        color: Color(0xFFC1C1C1),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    time: Text(
                                      state.announcements[0].time.toString(),
                                      style: const TextStyle(
                                        color: Color(0xFFC1C1C1),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    imageUrl: AppImages.cardBgImg,
                                    stringTime:
                                        state.announcements[0].time.toString(),
                                  ),
                                  // Events Section
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const LabelTextWidget(title: "Events"),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const EventsScreen(),
                                              ),
                                            );
                                          },
                                          child: const ViewAllText(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const EventsCard(
                                      textLabel: Text(
                                        'Leadership Camp',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      cardColor: Colors.white,
                                      imageAssetPath: AppImages.eventTwo),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBarWidget(title: "", isBackButton: false),
              body: Stack(
                children: [
                  Container(
                    color: Color(0xFF3A5B84).withOpacity(0.6),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F3F4),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          child: StudentShimmer(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
