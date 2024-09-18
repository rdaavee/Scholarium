import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_dtr/dtr_screen.dart';
import 'package:isHKolarium/features/screens/screen_event/events_screen.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/dtr_hours_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/event_widgets/events_card.dart';
import 'package:isHKolarium/features/screens/screen_schedule/schedule_screen.dart';
import 'package:isHKolarium/features/widgets/student_widgets/schedule_widgets/schedule_card.dart';
import 'package:isHKolarium/blocs/bloc_student/students_bloc.dart';
import 'package:isHKolarium/features/screens/screen_announcement/announcements_screen.dart';
import 'package:isHKolarium/features/widgets/student_widgets/announcement_widgets/announcement_card.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  late StudentsBloc studentBloc;

  @override
  void initState() {
    super.initState();
    final studentRepositoryImpl = StudentRepositoryImpl();
    studentBloc = StudentsBloc(studentRepositoryImpl);
    studentBloc.add(FetchLatestEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StudentsBloc>(
          create: (context) => studentBloc,
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
          print('Building UI with state: $state');
          if (state is StudentsLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is StudentsLoadedSuccessState) {
            return Scaffold(
              body: Stack(
                children: [
                  // Background image
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/image.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // Overlay color
                  Container(
                    color: ColorPalette.accentBlack.withOpacity(0.8),
                  ),
                  // Main content
                  Column(
                    children: [
                      Container(
                        height: 70.0,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Hi, ${state.users[0].firstName}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                  color: ColorPalette.accentWhite,
                                ),
                              ),
                              IconButton(
                                icon: Image.asset(
                                  'assets/icons/message.png',
                                  width: 27,
                                  height: 27,
                                  color: ColorPalette.accentWhite,
                                ),
                                onPressed: () {
                                  // logic here
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ScheduleScreen(),
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: ScheduleCard(
                                        scheduleDate: const Text(
                                          '10\nSept',
                                          style: TextStyle(
                                            fontSize: 27,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.w900,
                                            color: ColorPalette.accentBlack,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        scheduleTime: const Text(
                                          '10:30AM - 12:00PM',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Manrope',
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        roomName: const Text(
                                          'PTC-303',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Manrope',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        cardColor: Colors.white,
                                        imageUrl: 'assets/images/test-bg.png',
                                      ),
                                    ),
                                    Expanded(
                                      child: ScheduleCard(
                                        scheduleDate: const Text(
                                          '11\nSept',
                                          style: TextStyle(
                                            fontSize: 27,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        scheduleTime: const Text(
                                          '7:30AM - 8:30AM',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Manrope',
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        roomName: const Text(
                                          'CMA-123',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Manrope',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        cardColor: Colors.white,
                                        imageUrl: 'assets/images/test2-bg.png',
                                      ),
                                    ),
                                  ],
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
                                                  const AnnouncementsScreen(),
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
                                                  EventsScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "View All",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Manrope',
                                            fontWeight: FontWeight.bold,
                                            color: ColorPalette.primary,
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
