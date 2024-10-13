// duty_modal_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_bloc.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_event.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_state.dart';
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
    final globalRepositoryImpl = GlobalRepositoryImpl();
    profileBloc = ProfileBloc(globalRepositoryImpl);
    print(widget.schoolId);
    profileBloc.add(FetchUserDataEvent(schoolId: widget.schoolId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoadedSuccessState) {
          return SizedBox(
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
                      backgroundImage: state.users[0].profilePicture
                              .toString()
                              .isNotEmpty
                          ? NetworkImage(
                              state.users[0].profilePicture.toString())
                          : const AssetImage('assets/images/profile_image.png')
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
                        fontFamily: 'Manrope',
                        fontSize: 24,
                        color: Color(0xFF6D7278),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      state.users[0].schoolID ?? '',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
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
                          fontFamily: 'Manrope',
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
                  const SizedBox(height: 20),
                  const Divider(
                    thickness: 0.2,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  DtrHoursCard(
                    progress: (0 / 0).clamp(0.0, 1.0),
                    cardColor: Colors.white,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InfoSection(
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
                      const SizedBox(height: 15),
                      const DividerWidget(),
                      const SizedBox(height: 15),
                      InfoRow(
                          label: 'HK Type',
                          value: state.users[0].hkType.toString()),
                    ],
                  ),
                ],
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
