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
import 'package:isHKolarium/features/widgets/label_text_widget.dart';
import 'package:isHKolarium/features/widgets/no_data.dart';
import 'package:isHKolarium/features/widgets/professor_widgets/message_textfield.dart';
import 'package:isHKolarium/features/widgets/professor_widgets/post_button.dart';
import 'package:isHKolarium/features/widgets/professor_widgets/post_textfield.dart';
import 'package:isHKolarium/features/widgets/professor_widgets/professor_shimmer.dart';
import 'package:isHKolarium/features/widgets/student_widgets/announcement_widgets/announcement_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/duty_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/event_widgets/events_card.dart';
import 'package:isHKolarium/features/widgets/view_all_widget.dart';

class ProfessorHomeScreen extends StatefulWidget {
  const ProfessorHomeScreen({super.key});

  @override
  State<ProfessorHomeScreen> createState() => _ProfessorHomeScreenState();
}

class _ProfessorHomeScreenState extends State<ProfessorHomeScreen> {
  late ProfessorsBloc professorsBloc;
  late BottomNavBloc bottomNavBloc;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final professorRepository = ProfessorRepositoryImpl();
    final globalRepository = GlobalRepositoryImpl();
    professorsBloc = ProfessorsBloc(professorRepository, globalRepository);
    bottomNavBloc = BottomNavBloc(globalRepository);
    context.read<BottomNavBloc>().add(FetchUnreadCountEvent());
    professorsBloc.add(FetchLatestEvent());
  }

  Future<void> createPost() async {
    if (titleController.text.isEmpty || messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and body cannot be empty')),
      );
      return;
    }

    professorsBloc.add(ProfessorsCreatePostEvent(
      title: titleController.text,
      message: messageController.text,
    ));

    titleController.clear();
    messageController.clear();
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
                title: "Hello, ${state.users[0].firstName ?? 'Professor'}!",
                isBackButton: false,
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Container(
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
                                          const LabelTextWidget(
                                            title: 'Post something',
                                            fontSize: 18,
                                          ),
                                          const SizedBox(height: 10),
                                          PostTextField(
                                              controller: titleController),
                                          const SizedBox(height: 20),
                                          MessageTextField(
                                              controller: messageController),
                                          const SizedBox(height: 20),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: PostButton(
                                              onPressed: () {
                                                createPost();
                                                Navigator.of(context).pop();
                                              },
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
                                      backgroundColor: Colors.white,
                                      backgroundImage: state
                                                  .users[0].profilePicture !=
                                              null
                                          ? NetworkImage(
                                              state.users[0].profilePicture!)
                                          : AssetImage(
                                                  'assets/images/default_avatar.png')
                                              as ImageProvider,
                                    ),
                                    const SizedBox(width: 15),
                                    const Expanded(
                                      child: LabelTextWidget(
                                          title: 'Post something'),
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
                            const LabelTextWidget(title: 'Ongoing Duties'),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 205, // Adjust this height as needed
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.schedules.length,
                                itemBuilder: (context, index) {
                                  final schedule = state.schedules[index];
                                  return Row(
                                    children: [
                                      DutyCard(
                                        cardColor: ColorPalette.primary
                                            .withOpacity(0.6),
                                        schedule: schedule,
                                        students: schedule.students,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Announcements Section
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const LabelTextWidget(title: 'Announcements'),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AnnouncementsScreen(
                                            isBackButtonTrue: true,
                                          ),
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
                                state.announcements.isNotEmpty
                                    ? (state.announcements[0].title ??
                                        'No Title')
                                    : 'No Announcements',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6D7278),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              textBody: Text(
                                state.announcements.isNotEmpty
                                    ? (state.announcements[0].body ?? 'No Body')
                                    : 'No Body',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFC1C1C1),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              date: Text(
                                state.announcements.isNotEmpty
                                    ? (state.announcements[0].date ?? 'No Date')
                                    : 'No Date',
                                style: const TextStyle(
                                  color: Color(0xFFC1C1C1),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              time: Text(
                                state.announcements.isNotEmpty
                                    ? (state.announcements[0].time ?? 'No Time')
                                    : 'No Time',
                                style: const TextStyle(
                                  color: Color(0xFFC1C1C1),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              imageUrl: 'assets/images/card-bg.png',
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
                                  const LabelTextWidget(title: 'Events'),
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
                              imageAssetPath: 'assets/images/img1.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProfessorsErrorState) {
            return const Scaffold(
              body: NoData(
                title: 'No Data Available',
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
                          child: const ProfessorShimmer(),
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
