import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/constants/colors.dart';
import 'package:isHKolarium/features/students/bloc/students_bloc.dart';
import 'package:isHKolarium/features/students/widgets/announcement_card.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  void initState() {
    super.initState();
    context.read<StudentsBloc>().add(FetchAnnouncementEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentsBloc, StudentsState>(
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
                    child: Text(
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
                    decoration: BoxDecoration(
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
                          return GestureDetector(
                            child: AnnouncementCard(
                              textLabel: Text(
                                announcement.title,  
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6D7278),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              textBody: Text(
                                announcement.body,  
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                ),
                              ),
                              date: Text(announcement.date), 
                              time: Text(announcement.time),  
                              cardColor: Colors.white,
                            ),
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
          return Scaffold(
            backgroundColor: ColorPalette.accent,
            body: Center(child: Text('No Data')),
          );
        }
      },
    );
  }
}
