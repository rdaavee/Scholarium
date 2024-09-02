import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_dtr/dtr_screen.dart';
import 'package:isHKolarium/features/widgets/dtr_hours_card.dart';
import 'package:isHKolarium/features/screens/screen_event/events_screen.dart';
import 'package:isHKolarium/features/widgets/events_card.dart';
import 'package:isHKolarium/features/screens/screen_schedule/schedule_screen.dart';
import 'package:isHKolarium/features/widgets/schedule_card.dart';
import 'package:isHKolarium/blocs/bloc_student/students_bloc.dart';
import 'package:isHKolarium/features/screens/screen_announcement/announcements_screen.dart';
import 'package:isHKolarium/features/widgets/announcement_card.dart';

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
    final apiService = ApiService();
    studentBloc = StudentsBloc(apiService);
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
              backgroundColor: ColorPalette.accent,
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is StudentsLoadedSuccessState) {
            return Scaffold(
              backgroundColor: ColorPalette.primary,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Container(
                      height: 100.0,
                      color: ColorPalette.primary,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Hi, Ranier",
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: ColorPalette.accentWhite,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height - 100.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F3F4),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListView(
                          children: [
                            // Upcoming Duties
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ScheduleScreen(),
                                        ),
                                      );
                                    },
                                    child: const Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ScheduleCard(
                                          scheduleDate: Text(
                                            '10\nSept',
                                            style: TextStyle(
                                              fontSize: 27,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          scheduleTime: Text(
                                            '10:30AM - 12:00PM',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          roomName: Text(
                                            'PTC-303',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          cardColor: Color(0xFF6DD400),
                                        ),
                                        Positioned(
                                          top: -5.0,
                                          left: 20.0,
                                          child: Text(
                                            "Upcoming Duties",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF6D7278),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ScheduleScreen(),
                                        ),
                                      );
                                    },
                                    child: const Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ScheduleCard(
                                          scheduleDate: Text(
                                            '11\nSept',
                                            style: TextStyle(
                                              fontSize: 27,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          scheduleTime: Text(
                                            '7:30AM - 8:30AM',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          roomName: Text(
                                            'CMA-123',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          cardColor: Color(0xFF549E73),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Your DTR
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DtrScreen(),
                                  ),
                                );
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  DtrHoursCard(
                                    progress: (state.hours[0].totalhours /
                                            state.hours[0].targethours)
                                        .clamp(0.0, 1.0),
                                    cardColor: Colors.white,
                                  ),
                                  const Positioned(
                                    top: 15.0,
                                    left: 20.0,
                                    child: Text(
                                      "Your DTR",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6D7278),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Announcements
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
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
                                  child: AnnouncementCard(
                                    textLabel: Text(
                                      state.announcements[0].title.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6DD400),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    textBody: Text(
                                      state.announcements[0].body.toString(),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                        color: Color(0xFFC1C1C1),
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    date: Text(
                                      state.announcements[0].date.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(0xFFC1C1C1),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    time: Text(
                                      state.announcements[0].time.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(0xFFC1C1C1),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    cardColor: Colors.white,
                                  ),
                                ),
                                const Positioned(
                                  top: 15.0,
                                  left: 20.0,
                                  child: Text(
                                    "Announcements",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6D7278),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Events
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
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
                                  child: const EventsCard(
                                    textLabel: Text(
                                      'Sunkissed Lola Concert',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    cardColor: Colors.white,
                                    imageAssetPath: 'assets/images/image_2.jpg',
                                  ),
                                ),
                                const Positioned(
                                  top: 15.0,
                                  left: 20.0,
                                  child: Text(
                                    "Events",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6D7278),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
