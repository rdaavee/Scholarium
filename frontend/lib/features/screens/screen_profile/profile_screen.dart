import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_bloc.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_event.dart';
import 'package:isHKolarium/blocs/bloc_profile/profile_state.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/profile_widgets/profile_circle.dart';
import '../../widgets/profile_widgets/profile_account_option.dart';
import '../../widgets/profile_widgets/profile_account_section.dart';
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
    final apiService = ApiService();
    profileBloc = ProfileBloc(apiService);
    _initialize();
  }

  Future<void> _initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    profileBloc.add(LoadProfileEvent(token: token));
  }

  void _onProfileUpdated() {
    _initialize();
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
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileLoadedSuccessState) {
            return Scaffold(
              body: Stack(
                children: [
                  // Background image
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/image.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Optional overlay color
                  Container(
                    color: ColorPalette.primary.withOpacity(0.6),
                  ),
                  // Main content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 20.0),
                        child: Container(
                          height: 120.0,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Profile",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                  color: ColorPalette.accentWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F3F4),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              children: [
                                const SizedBox(height: 50),
                                ProfileCircle(
                                  profilePictureUrl: state.profilePicture,
                                ),
                                const SizedBox(height: 80),
                                InfoSection(
                                  title: 'BASIC INFORMATION',
                                  infoRows: [
                                    const SizedBox(height: 20),
                                    InfoRow(label: 'Name', value: state.name),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(label: 'Email', value: state.email),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'Student ID',
                                        value: state.studentId),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'Gender', value: state.gender),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'Contact #',
                                        value: state.contact),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'Address', value: state.address),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'HK Type', value: state.hkType),
                                    const SizedBox(height: 15),
                                    const DividerWidget(),
                                    const SizedBox(height: 15),
                                    InfoRow(
                                        label: 'Status', value: state.status),
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
            return Scaffold(
              body: Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
