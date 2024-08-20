import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/features/login/bloc/login_bloc.dart';
import 'package:isHKolarium/features/login/widgets/login_and_text.dart';
import 'package:isHKolarium/features/login/widgets/login_form.dart';
import 'package:isHKolarium/features/professors/ui/professor_home_page.dart';
import 'package:isHKolarium/features/students/ui/student_home_page.dart';

class LoginPage extends StatefulWidget {
  static String routeName = 'LoginPage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginBloc loginBloc = LoginBloc();

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
              builder: (context) => StudentHomePage(),
            ),
          );
        } else if (state is LoginNavigateToProfessorHomePageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfessorHomePage(),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: ListView(
            children: [
              SizedBox(height: 50),
              LogoAndText(),
              SizedBox(height: 30),
              LoginForm(loginBloc: loginBloc),
            ],
          ),
        );
      },
    );
  }
}
