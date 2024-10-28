// duty_modal_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_bloc.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_event.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_state.dart';
import 'package:isHKolarium/config/assets/app_images.dart';
import 'package:isHKolarium/features/screens/screen_schedule/schedule_screen.dart';
import 'package:isHKolarium/features/widgets/forgot_password_widgets/custom_elevatedbutton.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';
import 'package:isHKolarium/features/widgets/profile_widgets/profile_divider.dart';
import 'package:isHKolarium/features/widgets/profile_widgets/profile_info_data.dart';
import 'package:isHKolarium/features/widgets/profile_widgets/profile_info_section.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/dtr_hours_card.dart';

class ProfileModalBottomSheet extends StatefulWidget {
  final String schoolId;

  const ProfileModalBottomSheet({
    super.key,
    required this.schoolId,
  });

  @override
  State<ProfileModalBottomSheet> createState() =>
      _ProfileModalBottomSheetState();
}

class _ProfileModalBottomSheetState extends State<ProfileModalBottomSheet> {
  late ProfileBloc profileBloc;
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final globalRepository = GlobalRepositoryImpl();
    final studentRepository = StudentRepositoryImpl();
    profileBloc = ProfileBloc(globalRepository, studentRepository);
    profileBloc.add(FetchUserDataEvent(schoolId: widget.schoolId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return const Center(child: LoadingCircular());
        } else if (state is ProfileLoadedSuccessState) {
          print(state.hours[0].targethours);
          return Scaffold(
            body: SizedBox(
              height: 880,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: CircleAvatar(
                        radius: 75.0,
                        backgroundColor: const Color(0xFFEDEDED),
                        backgroundImage:
                            state.users[0].profilePicture.toString().isNotEmpty
                                ? NetworkImage(
                                    state.users[0].profilePicture.toString())
                                : const AssetImage(AppImages.defaultPfp)
                                    as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Name
                    Center(
                      child: Text(
                        '${state.users[0].firstName} ${state.users[0].lastName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF6D7278),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        state.users[0].schoolID ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6D7278),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    // Active/Inactive Status
                    Center(
                      child: Chip(
                        label: Text(
                          state.users[0].status == 'Active'
                              ? 'Active'
                              : 'Inactive',
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        backgroundColor: state.users[0].status == 'Active'
                            ? const Color(0xFF6DD400)
                            : Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: state.users[0].status == 'Active'
                                ? const Color(0xFF6DD400)
                                : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 0.2,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    if (state.users[0].role == "Student") ...[
                      DtrHoursCard(
                        progress: (state.hours[0].totalhours /
                                state.hours[0].targethours)
                            .clamp(0.0, 1.0),
                        cardColor: Colors.white,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: CustomElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ScheduleScreen(
                                    role: "Student",
                                    isAdmin: "Yes",
                                    schoolID: state.users[0].schoolID,
                                    isAppBarBack: true,
                                  );
                                },
                              ),
                            );
                          },
                          text: 'Schedule',
                        ),
                      ),
                    ],
                    Expanded(
                      child: SingleChildScrollView(
                        child: InfoSection(
                          title: 'BASIC INFORMATION',
                          infoRows: [
                            const SizedBox(height: 15),
                            InfoRow(
                                label: 'Email',
                                value: state.users[0].email.toString()),
                            const SizedBox(height: 15),
                            const DividerWidget(),
                            const SizedBox(height: 15),
                            InfoRow(
                                label: 'Gender',
                                value: state.users[0].gender.toString()),
                            const SizedBox(height: 15),
                            const DividerWidget(),
                            const SizedBox(height: 15),
                            InfoRow(
                                label: 'Contact #',
                                value: state.users[0].contact.toString()),
                            const SizedBox(height: 15),
                            const DividerWidget(),
                            const SizedBox(height: 15),
                            InfoRow(
                                label: 'Address',
                                value: state.users[0].address.toString()),
                            if (state.users[0].role == "Student") ...[
                              const SizedBox(height: 15),
                              const DividerWidget(),
                              const SizedBox(height: 15),
                              InfoRow(
                                  label: 'HK Type',
                                  value: state.users[0].hkType.toString()),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is ProfileErrorState) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
