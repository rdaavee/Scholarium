import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/blocs/bloc_login/login_bloc.dart';
import 'package:isHKolarium/features/screens/screen_admin/admin_home_page.dart';
import 'package:isHKolarium/features/widgets/login_form.dart';
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
    final ApiService apiService = ApiService(); // Initialize ApiService
    loginBloc = LoginBloc(apiService); // Pass ApiService to LoginBloc
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminHomePage()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF0F3F4),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'is',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          letterSpacing: 5,
                        ),
                      ),
                      TextSpan(
                        text: 'HK',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 5,
                        ),
                      ),
                      TextSpan(
                        text: 'olarium',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
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
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D7278),
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
        );
      },
    );
  }
}
