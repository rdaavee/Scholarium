import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_bloc.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_event.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_state.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';
import 'package:isHKolarium/features/widgets/no_data.dart';

import '../../widgets/profile_widgets/profile_account_option.dart';
import '../../widgets/profile_widgets/profile_account_section.dart';
import '../../widgets/profile_widgets/profile_circle.dart';
import '../../widgets/profile_widgets/profile_divider.dart';
import '../../widgets/profile_widgets/profile_info_data.dart';
import '../../widgets/profile_widgets/profile_info_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    final apiService = GlobalRepositoryImpl();
    profileBloc = ProfileBloc(apiService);
    profileBloc.add(FetchProfileEvent());
    context.read<BottomNavBloc>().add(FetchUnreadCountEvent());
  }

  void _onProfileUpdated() {
    profileBloc.add(FetchProfileEvent());
  }

  void _pickImage() async {
    print("Pick Image Hit");
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileBloc.add(PickImageEvent(pickedFile.path));
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (context) => profileBloc),
      ],
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            print("Loading state triggered");
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileLoadedSuccessState) {
            return Scaffold(
              appBar: const AppBarWidget(
                title: "Profile",
                isBackButton: false,
              ),
              body: Stack(
                children: [
                  Container(
                    color: ColorPalette.primary.withOpacity(0.6),
                  ),
                  Column(
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
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F3F4),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              children: [
                                const SizedBox(height: 50),
                                ProfileCircle(
                                  profilePicture:
                                      state.users[0].profilePicture.toString(),
                                  onTap: _pickImage,
                                ),
                                const SizedBox(height: 80),
                                InfoSection(
                                  title: 'BASIC INFORMATION',
                                  infoRows: [
                                    const SizedBox(height: 20),
                                    InfoRow(
                                        label: 'Name',
                                        value:
                                            "${state.users[0].firstName} ${state.users[0].middleName} ${state.users[0].lastName}"),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'Email',
                                        value: state.users[0].email.toString()),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'School ID',
                                        value:
                                            state.users[0].schoolID.toString()),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'Gender',
                                        value:
                                            state.users[0].gender.toString()),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'Contact #',
                                        value:
                                            state.users[0].contact.toString()),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'Address',
                                        value:
                                            state.users[0].address.toString()),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'HK Type',
                                        value:
                                            state.users[0].hkType.toString()),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'Status',
                                        value:
                                            state.users[0].status.toString()),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                const AccountSection(),
                                const SizedBox(height: 20),
                                AccountOptions(
                                  onProfileUpdated: _onProfileUpdated,
                                  onLogout: () {
                                    BlocProvider.of<ProfileBloc>(context)
                                        .add(LogoutEvent(context: context));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is LogoutLoadedSuccessState) {
            Navigator.pushReplacementNamed(context, '/login');
            return Container();
          } else if (state is LogoutErrorState) {
            return NoData();
          } else {
            return LoadingCircular();
          }
        },
      ),
    );
  }
}
