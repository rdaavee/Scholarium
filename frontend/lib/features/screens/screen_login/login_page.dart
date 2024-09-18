import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/blocs/bloc_login/login_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_admin/admin_home_page.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/login_form.dart';
import 'package:isHKolarium/features/screens/screen_bottom_nav/bottom_navigation_provider.dart';
import 'package:isHKolarium/features/screens/screen_professor/professor_screen.dart';

class LoginPage extends StatefulWidget {
  static String routeName = 'LoginPage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    final ApiService apiService = ApiService();
    loginBloc = LoginBloc(apiService);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) => current is LoginActionState,
      buildWhen: (previous, current) => current is! LoginActionState,
      listener: (context, state) {
        if (state is LoginNavigateToStudentHomePageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentHomePage(),
            ),
          );
        } else if (state is LoginNavigateToProfessorHomePageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfessorScreen(),
            ),
          );
        } else if (state is LoginNavigateToAdminHomePageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminHomePage(),
            ),
          );
        }
      },
      builder: (context, state) {
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
              // Overlay color
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorPalette.primary.withOpacity(0.8),
                      Colors.black.withOpacity(.9)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Content
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'is',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              letterSpacing: 5,
                            ),
                          ),
                          TextSpan(
                            text: 'HK',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.textAccent,
                              letterSpacing: 5,
                            ),
                          ),
                          TextSpan(
                            text: 'olarium',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              letterSpacing: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Login your account',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 30),
                            LoginForm(loginBloc: loginBloc),
                            const SizedBox(height: 50),
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
      },
    );
  }
}
