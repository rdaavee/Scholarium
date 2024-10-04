import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/blocs/bloc_student/students_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/student_widgets/announcement_widgets/announcement_card.dart';

class AnnouncementsScreen extends StatefulWidget {
  final String role;

  const AnnouncementsScreen({super.key, required this.role});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  late AdminBloc adminBloc;
  late StudentsBloc studentsBloc;

  @override
  void initState() {
    super.initState();

    if (widget.role == "Admin") {
      final adminRepositoryImpl = AdminRepositoryImpl();
      adminBloc = AdminBloc(adminRepositoryImpl);
      adminBloc.add(FetchAnnouncementsEvent());
    } else if (widget.role == "Student") {
      final studentRepositoryImpl = StudentRepositoryImpl();
      final globalRepositoryImpl = GlobalRepositoryImpl();
      studentsBloc = StudentsBloc(studentRepositoryImpl, globalRepositoryImpl);
      studentsBloc.add(FetchAnnouncementEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        if (widget.role == "Admin")
          BlocProvider<AdminBloc>(
            create: (context) => adminBloc,
          ),
        if (widget.role == "Student")
          BlocProvider<StudentsBloc>(
            create: (context) => studentsBloc,
          ),
      ],
      child: Scaffold(
        appBar: widget.role == "Admin"
            ? const AppBarWidget(
                title: "Announcements",
                isBackButton: false,
              )
            : const AppBarWidget(
                title: "Announcements",
                isBackButton: true,
              ),
        backgroundColor: ColorPalette.primary.withOpacity(0.9),
        body: widget.role == "Admin"
            ? BlocConsumer<AdminBloc, AdminState>(
                listener: (context, state) {
                  if (state is AdminErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AdminLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AdminLoadedSuccessState) {
                    return _buildAnnouncementsList(state.announcements);
                  } else if (state is AdminErrorState) {
                    return Scaffold(
                      body: Center(child: Text('Error: ${state.message}')),
                    );
                  }
                  return const Scaffold(
                    body: Center(child: Text('No Data Available')),
                  );
                },
              )
            : BlocConsumer<StudentsBloc, StudentsState>(
                listener: (context, state) {
                  if (state is StudentsErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is StudentsLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is StudentsLoadedSuccessState) {
                    return _buildAnnouncementsList(state.announcements);
                  } else if (state is StudentsErrorState) {
                    return Scaffold(
                      body: Center(child: Text('Error: ${state.message}')),
                    );
                  }
                  return const Scaffold(
                    body: Center(child: Text('No Data Available')),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildAnnouncementsList(List<AnnouncementModel> announcements) {
    return Column(
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
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementsScreen(role:)))
                        },
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
    );
  }
}
