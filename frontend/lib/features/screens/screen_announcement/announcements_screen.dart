import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/blocs/bloc_student/students_bloc.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/student_widgets/announcement_widgets/announcement_card.dart';

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
    final studentRepositoryImpl = StudentRepositoryImpl();
    studentBloc = StudentsBloc(studentRepositoryImpl);
    studentBloc.add(FetchAnnouncementEvent());
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
              appBar: const AppBarWidget(
                  title: "Announcements", isBackButton: true),
              backgroundColor: ColorPalette.primary.withOpacity(0.9),
              body: Column(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height - 100.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F3F4),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
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
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6D7278),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    textBody: Text(
                                      announcement.body.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                                    date: Text(announcement.date.toString()),
                                    time: Text(announcement.time.toString()),
                                    imageUrl: 'assets/images/card-bg.png',
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
              appBar: const AppBarWidget(
                  title: "Announcements", isBackButton: true),
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
