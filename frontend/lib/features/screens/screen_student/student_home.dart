import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_announcement/announcement.dart';
import 'package:isHKolarium/features/screens/screen_dtr/dtr_screen.dart';
import 'package:isHKolarium/features/screens/screen_event/events_screen.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/dtr_hours_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/event_widgets/events_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/schedule_widgets/schedule_card.dart';
import 'package:isHKolarium/blocs/bloc_student/students_bloc.dart';
import 'package:isHKolarium/features/widgets/student_widgets/announcement_widgets/announcement_card.dart';

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
    studentBloc.add(FetchLatestEvent());
    bottomNavBloc = BottomNavBloc();
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
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is StudentsLoadedSuccessState) {
            return Scaffold(
              appBar: AppBarWidget(
                  title: "Hello ${state.users[0].firstName}",
                  isBackButton: false),
              body: Stack(
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
                                  height: 30,
                                ),
                                // Upcoming Duties Section
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Upcoming Duties",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6D7278),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          bottomNavBloc
                                              .add(BottomNavItemSelected(1));
                                        },
                                        child: const Text(
                                          "View All",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.bold,
                                            color: ColorPalette.viewAllColor,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      ScheduleCard(
                                        scheduleDate: Text(
                                          state.todaySchedule[0].date
                                                      .toString() ==
                                                  "No Upcoming Schedule"
                                              ? state.todaySchedule[0].date
                                                  .toString()
                                              : _formatDate(state
                                                  .todaySchedule[0].date
                                                  .toString()),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.w900,
                                            color: ColorPalette.accentBlack,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        scheduleTime: Text(
                                          state.todaySchedule[0].time
                                                      .toString() ==
                                                  ""
                                              ? state.todaySchedule[0].time
                                                  .toString()
                                              : _formatTime(state
                                                  .todaySchedule[0].time
                                                  .toString()),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Manrope',
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        roomName: Text(
                                          state.todaySchedule[0].room
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Manrope',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        cardColor: Colors.white,
                                        imageUrl: 'assets/images/test-img.png',
                                      ),
                                      const SizedBox(width: 5),
                                      ScheduleCard(
                                        scheduleDate: Text(
                                          state.nextSchedule[0].date
                                                      .toString() ==
                                                  "No Upcoming Schedule"
                                              ? state.nextSchedule[0].date
                                                  .toString()
                                              : _formatDate(state
                                                  .nextSchedule[0].date
                                                  .toString()),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        scheduleTime: Text(
                                          state.nextSchedule[0].time
                                                      .toString() ==
                                                  ""
                                              ? state.nextSchedule[0].time
                                                  .toString()
                                              : _formatTime(state
                                                  .nextSchedule[0].time
                                                  .toString()),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Manrope',
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        roomName: Text(
                                          state.nextSchedule[0].room.toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Manrope',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        cardColor: Colors.white,
                                        imageUrl: 'assets/images/test-img.png',
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
                                      const Text(
                                        "Your DTR",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6D7278),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const DtrScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "View All",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.bold,
                                            color: ColorPalette.viewAllColor,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
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
                                      const Text(
                                        "Announcements",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6D7278),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AnnouncementsScreen(
                                                      role: "Student"),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "View All",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.bold,
                                            color: ColorPalette.viewAllColor,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AnnouncementCard(
                                  textLabel: Text(
                                    state.announcements[0].title.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6D7278),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  textBody: Text(
                                    state.announcements[0].body.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Manrope',
                                      color: Color(0xFFC1C1C1),
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  date: Text(
                                    state.announcements[0].date.toString(),
                                    style: const TextStyle(
                                      fontFamily: 'Manrope',
                                      color: Color(0xFFC1C1C1),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  time: Text(
                                    state.announcements[0].time.toString(),
                                    style: const TextStyle(
                                      fontFamily: 'Manrope',
                                      color: Color(0xFFC1C1C1),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  imageUrl: 'assets/images/card-bg.png',
                                ),
                                // Events Section
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15, top: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Events",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6D7278),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
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
                                        child: const Text(
                                          "View All",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.bold,
                                            color: ColorPalette.viewAllColor,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const EventsCard(
                                  textLabel: Text(
                                    'Sunkissed Lola Concert',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Manrope',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  cardColor: Colors.white,
                                  imageAssetPath: 'assets/images/image_2.jpg',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
