import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/professor_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/blocs/bloc_professor/professors_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_announcement/announcement.dart';
import 'package:isHKolarium/features/screens/screen_event/events_screen.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';
import 'package:isHKolarium/features/widgets/student_widgets/announcement_widgets/announcement_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/duty_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/event_widgets/events_card.dart';

class ProfessorHomeScreen extends StatefulWidget {
  const ProfessorHomeScreen({super.key});

  @override
  State<ProfessorHomeScreen> createState() => _ProfessorHomeScreenState();
}

class _ProfessorHomeScreenState extends State<ProfessorHomeScreen> {
  late ProfessorsBloc professorsBloc;
  late BottomNavBloc bottomNavBloc;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final professorRepository = ProfessorRepositoryImpl();
    final globalRepository = GlobalRepositoryImpl();
    professorsBloc = ProfessorsBloc(professorRepository, globalRepository);
    bottomNavBloc = BottomNavBloc(globalRepository);
    bottomNavBloc.add(FetchUnreadCountEvent());
    professorsBloc.add(ProfessorsInitialEvent());
    professorsBloc.add(FetchLatestEvent());
  }

  Future<void> createPost() async {
    if (titleController.text.isEmpty || bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and body cannot be empty')),
      );
      return;
    }

    professorsBloc.add(ProfessorsCreatePostEvent(
      title: titleController.text,
      body: bodyController.text,
    ));

    titleController.clear();
    bodyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfessorsBloc>(
          create: (context) => professorsBloc,
        ),
        BlocProvider<BottomNavBloc>(
          create: (context) => bottomNavBloc,
        ),
      ],
      child: BlocConsumer<ProfessorsBloc, ProfessorsState>(
        bloc: professorsBloc,
        listener: (BuildContext context, ProfessorsState state) {},
        builder: (context, state) {
          if (state is ProfessorsLoadedSuccessState) {
            return Scaffold(
              appBar: AppBarWidget(
                  title: "Hello, ${state.users[0].firstName}!",
                  isBackButton: false),
              body: Column(
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Center(
                                            child: SizedBox(
                                              width: 100,
                                              child: Divider(
                                                height: 20,
                                                thickness: 0.8,
                                                color: Color(0xFFC1C1C1),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Post Something',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Manrope',
                                              fontSize: 18,
                                              color: Color(0xFF6D7278),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: titleController,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              hintText: 'Create a post',
                                              labelStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Manrope',
                                                fontSize: 13,
                                              ),
                                              floatingLabelStyle:
                                                  const TextStyle(
                                                      fontFamily: 'Manrope',
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          ColorPalette.primary),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                borderSide: const BorderSide(
                                                    color: ColorPalette.primary,
                                                    width: 2),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              hoverColor: ColorPalette.primary,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0,
                                              fontFamily: 'Manrope',
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextField(
                                            controller: bodyController,
                                            maxLines: 5,
                                            decoration: InputDecoration(
                                              hintText: 'Write Something',
                                              labelStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Manrope',
                                                fontSize: 13,
                                              ),
                                              floatingLabelStyle:
                                                  const TextStyle(
                                                      fontFamily: 'Manrope',
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          ColorPalette.primary),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                borderSide: const BorderSide(
                                                    color: ColorPalette.primary,
                                                    width: 2),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              hoverColor: ColorPalette.primary,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0,
                                              fontFamily: 'Manrope',
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                createPost();
                                                Navigator.of(context).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    ColorPalette.btnColor,
                                                minimumSize:
                                                    const Size(395, 55),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 15),
                                              ).copyWith(
                                                elevation:
                                                    ButtonStyleButton.allOrNull(
                                                        0.0),
                                                backgroundColor:
                                                    WidgetStateProperty
                                                        .resolveWith<Color>(
                                                  (Set<WidgetState> states) {
                                                    if (states.contains(
                                                        WidgetState.hovered)) {
                                                      return ColorPalette
                                                          .primary;
                                                    }
                                                    return const Color(
                                                        0xFFC1C1C1);
                                                  },
                                                ),
                                              ),
                                              child: const Text(
                                                'Post',
                                                style: TextStyle(
                                                  fontFamily: 'Manrope',
                                                  fontSize: 11.5,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.transparent),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      radius: 25,
                                      child: const Icon(Icons.person,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text(
                                        'Post something',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Manrope',
                                          fontSize: 15,
                                          color: Color(0xFFC1C1C1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 0.2,
                              color: Color(0xFF6D7278),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Ongoing Duties',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6D7278),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.schedules.length,
                                itemBuilder: (context, index) {
                                  final schedule = state.schedules[index];
                                  return Column(
                                    children: [
                                      DutyCard(
                                        cardColor: ColorPalette.primary,
                                        time: schedule.time,
                                        roomName: schedule.room,
                                        students: schedule.students,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
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
                                                  isBackButtonTrue: true),
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
                                'Leadership Camp',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Manrope',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              cardColor: Colors.white,
                              imageAssetPath: 'assets/images/img1.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfessorsErrorState) {
            return const Scaffold(
              body: Center(child: Text('Error loading data')),
            );
          } else {
            return const Scaffold(
              body: Center(child: LoadingCircular()),
            );
          }
        },
      ),
    );
  }
}
