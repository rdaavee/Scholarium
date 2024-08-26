import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/constants/colors.dart';
import 'package:isHKolarium/features/dtr/widgets/dtr_card.dart';
import 'package:isHKolarium/features/events/ui/events_screen.dart';
import 'package:isHKolarium/features/events/widgets/events_card.dart';
import 'package:isHKolarium/features/schedule/ui/schedule_screen.dart';
import 'package:isHKolarium/features/schedule/widgets/schedule_card.dart';
import 'package:isHKolarium/features/students/bloc/students_bloc.dart';
import 'package:isHKolarium/features/announcements/ui/announcements_screen.dart';
import 'package:isHKolarium/features/announcements/widgets/announcement_card.dart';

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
                        child: ListView.builder(
                          itemCount: state.announcements.length,
                          itemBuilder: (context, index) {
                            final announcement = state.announcements[index];
                            final hours = state.hours[index];
                            final progress =
                                (hours.totalhours / hours.targethours)
                                    .clamp(0.0, 1.0);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                          announcement.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF6DD400),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        textBody: Text(
                                          announcement.body,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Inter',
                                            color: Color(0xFFC1C1C1),
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        date: Text(
                                          announcement.date,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFFC1C1C1),
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        time: Text(
                                          announcement.time,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFFC1C1C1),
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        cardColor: Colors.white,
                                      ),
                                    ),
                                    Positioned(
                                      top: 20.0,
                                      left: 25.0,
                                      child: const Text(
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
                                      child: EventsCard(
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
                                        imageAssetPath:
                                            'assets/images/image_2.jpg',
                                      ),
                                    ),
                                    Positioned(
                                      top: 20.0,
                                      left: 25.0,
                                      child: const Text(
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
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    DTRCard(
                                      progress: progress,
                                      cardColor: Colors.white,
                                    ),
                                    Positioned(
                                      top: 20.0,
                                      left: 25.0,
                                      child: const Text(
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
                                SizedBox(
                                  height: 10,
                                ),
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
                                              // TODO: Fix issue where the bottom navigation in ScheduleScreen becomes hidden or invisible when an upcoming duty is clicked. Ensure that the bottomNav remains visible and functional.
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            ScheduleCard(
                                              scheduleDate: Text(
                                                '10\nSept',
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              scheduleTime: Text(
                                                '10:30AM - 12:00PM',
                                                style: const TextStyle(
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
                                              top: 0.0,
                                              left: 26.0,
                                              child: const Text(
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
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            ScheduleCard(
                                              scheduleDate: Text(
                                                '11\nSept',
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              scheduleTime: Text(
                                                '7:30AM - 8:30AM',
                                                style: const TextStyle(
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
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: ColorPalette.primary,
              body: Center(child: Text('No Data')),
            );
          }
        },
      ),
    );
  }
}
