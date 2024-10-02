// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/screens/screen_bottom_nav/bottom_navigation_page.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/login_form.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'LoginPage';

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthenticationBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = AuthenticationBloc(GlobalRepositoryImpl());
    _initialize();
  }

  void _initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getString('login');
    final schoolID = prefs.getString('schoolID').toString();
    final password = prefs.getString('password').toString();
    if (isLogin == "true") {
      _loginBloc.add(LoginAutomaticEvent(schoolID, password));
    } else {}
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }

  void _showSnackBar(String title, String message, ContentType contentType) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      bloc: _loginBloc,
      listener: (context, state) {
        if (state is LoginLoadingState) {
          const Center(child: CircularProgressIndicator());
        } else if (state is LoginNavigateToStudentHomePageActionState) {
          _showSnackBar(
              'Success', 'Student Login Successfully', ContentType.success);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const BottomNavigationPage(isRole: "Student"),
            ),
          );
        } else if (state is LoginNavigateToProfessorHomePageActionState) {
          _showSnackBar(
              'Success', 'Professor Login Successfully', ContentType.success);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const BottomNavigationPage(isRole: "Professor"),
            ),
          );
        } else if (state is LoginNavigateToAdminHomePageActionState) {
          _showSnackBar(
              'Success', 'Admin Login Successfully', ContentType.success);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigationPage(isRole: "Admin"),
            ),
          );
        } else if (state is LoginErrorState) {
          _showSnackBar('Error', state.errorMessage, ContentType.failure);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              _buildBackground(),
              if (state is LoginLoadingState)
                const Center(child: CircularProgressIndicator())
              else
                _buildLoginForm(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackground() {
    return Stack(
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorPalette.primary.withOpacity(0.8),
                Colors.black.withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
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
                  LoginForm(loginBloc: _loginBloc),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
