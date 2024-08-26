import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/constants/colors.dart';
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
              backgroundColor: ColorPalette.accent,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Container(
                      height: 100.0,
                      color: ColorPalette.accent,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Announcements"),
                                    GestureDetector(
                                      child: const Text("View All"),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AnnouncementsPage(),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  child: AnnouncementCard(
                                    textLabel: Text(
                                      announcement.title,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6D7278),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    textBody: Text(
                                      announcement.body,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    date: Text(announcement.date),
                                    time: Text(announcement.time),
                                    cardColor: Colors.white,
                                  ),
                                ),
                                const Text("Your DTR"),
                                const Text(
                                  'Make sure to fill up this bar so you can renew your scholar.\nWork hard Flames!',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const Text(
                                  'Progress',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 20),
                                LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 10,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: ColorPalette.accent,
              body: Center(child: Text('No Data')),
            );
          }
        },
      ),
    );
  }
}
