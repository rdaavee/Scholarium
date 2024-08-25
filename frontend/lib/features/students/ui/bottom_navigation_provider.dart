import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/features/login/bloc/login_bloc.dart';
import 'package:isHKolarium/features/students/bloc/students_bloc.dart';
import 'package:isHKolarium/features/bottom_nav/bloc/bottom_nav_bloc.dart';
import 'package:isHKolarium/features/students/widgets/bottom_nav_widget.dart';
import 'package:isHKolarium/features/students/widgets/loading_widget.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final StudentsBloc studentBloc = StudentsBloc();
  final BottomNavBloc bottomNavBloc = BottomNavBloc();

  @override
  void initState() {
    super.initState();
    studentBloc.add(StudentInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bottomNavBloc,
      child: BlocConsumer<StudentsBloc, StudentsState>(
        bloc: studentBloc,
        listener: (context, state) {},
        builder: (context, studentState) {
          if (studentState is StudentsLoadingState) {
            return LoadingWidget();
          } else if (studentState is StudentLoadedSuccessState) {
            return BottomNavWidget();
          } else if (studentState is LoginErrorState) {
            // return ErrorWidget();
          }
          return SizedBox();
        },
      ),
    );
  }
}
