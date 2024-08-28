import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/constants/colors.dart';
import 'package:isHKolarium/features/students/bloc/students_bloc.dart';
import 'package:isHKolarium/features/announcements/widgets/announcement_card.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsScreen> {
  late StudentsBloc studentBloc;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService();
    studentBloc = StudentsBloc(apiService);
    studentBloc.add(FetchAllEvent());
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
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
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
                    ],
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
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: AnnouncementCard(
                                    textLabel: Text(
                                      announcement.title.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6D7278),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    textBody: Text(
                                      announcement.body.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    date: Text(announcement.date.toString()),
                                    time: Text(announcement.time.toString()),
                                    cardColor: Colors.white,
                                  ),
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
