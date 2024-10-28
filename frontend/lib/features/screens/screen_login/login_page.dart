// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_authentication/authentication_bloc.dart';
import 'package:isHKolarium/features/screens/screen_bottom_nav/bottom_navigation_page.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/background_widget.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/login_form_widget.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';
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
    if (isLogin == "true") {
      final schoolID = prefs.getString('schoolID').toString();
      final password = prefs.getString('password').toString();
      _loginBloc.add(LoginAutomaticEvent(schoolID, password));
    }
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
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundWidget(),
          BlocConsumer<AuthenticationBloc, AuthenticationState>(
            bloc: _loginBloc,
            listener: (context, state) {
              if (state is LoginNavigateToStudentHomePageActionState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BottomNavigationPage(isRole: "Student"),
                  ),
                );
                // _showSnackBar('Success', 'Student Login Successfully',
                //     ContentType.success);
              } else if (state is LoginNavigateToProfessorHomePageActionState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BottomNavigationPage(isRole: "Professor"),
                  ),
                );
                // _showSnackBar('Success', 'Professor Login Successfully',
                //     ContentType.success);
              } else if (state is LoginNavigateToAdminHomePageActionState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BottomNavigationPage(isRole: "Admin"),
                  ),
                );
                // _showSnackBar(
                //     'Success', 'Admin Login Successfully', ContentType.success);
              } else if (state is LoginErrorState) {
                _showSnackBar('Error', state.errorMessage, ContentType.failure);
              }
            },
            builder: (context, state) {
              if (state is LoginLoadingState ||
                  state is LoginNavigateToAdminHomePageActionState ||
                  state is LoginNavigateToStudentHomePageActionState ||
                  state is LoginNavigateToProfessorHomePageActionState) {
                return const Center(child: LoadingCircular());
              } else {
                return LoginFormWidget(loginBloc: _loginBloc);
              }
            },
          ),
        ],
      ),
    );
  }
}
