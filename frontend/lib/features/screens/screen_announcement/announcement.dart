import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/blocs/bloc_student/students_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';
import 'package:isHKolarium/features/widgets/student_widgets/announcement_widgets/announcement_card.dart';
import 'package:shimmer/shimmer.dart';

class AnnouncementsScreen extends StatefulWidget {
  final bool isBackButtonTrue;

  const AnnouncementsScreen({super.key, required this.isBackButtonTrue});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  late AdminBloc adminBloc;
  late StudentsBloc studentsBloc;

  @override
  void initState() {
    super.initState();

    final adminRepository = AdminRepositoryImpl();
    final globalRepository = GlobalRepositoryImpl();
    adminBloc = AdminBloc(adminRepository, globalRepository);
    adminBloc.add(FetchAnnouncementsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminBloc>(
          create: (context) => adminBloc,
        ),
      ],
      child: Scaffold(
          appBar: AppBarWidget(
            title: "Announcements",
            isBackButton: widget.isBackButtonTrue,
          ),
          backgroundColor: ColorPalette.primary.withOpacity(0.9),
          body: BlocConsumer<AdminBloc, AdminState>(
            listener: (context, state) {
              if (state is AdminErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is AdminLoadingState) {
                return LoadingCircular();
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
          )),
    );
  }

  String _formatTime(String time) {
    final DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('h:mm a').format(parsedTime);
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
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6D7278),
                              letterSpacing: 0.5,
                            ),
                          ),
                          textBody: Text(
                            announcement.body.toString(),
                            style: const TextStyle(
                            ),
                          ),
                          date: Text(announcement.date.toString()),
                          time: Text(_formatTime(announcement.time.toString())),
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
  
  Widget _buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.builder(
      itemCount: 5, // Number of shimmer items to show
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Container(
            height: 80, // Height of the shimmer card
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    ),
  );
}
}
