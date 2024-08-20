import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/features/login/bloc/login_bloc.dart';
import 'package:isHKolarium/features/students/bloc/students_bloc.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final StudentsBloc studentBloc = StudentsBloc();

  @override
  void initState() {
    super.initState();
    studentBloc.add(StudentInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentsBloc, StudentsState>(
      bloc: studentBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is StudentsLoadingState) {
          return _buildLoading();
        } else if (state is StudentLoadedSuccessState) {
          return _buildStudentHome();
        } else if (state is LoginErrorState) {
          return _buildError();
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildStudentHome() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'isHKolarium',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Text('Hello, Student'),
      ),
    );
  }

  Widget _buildError() {
    return Scaffold(
      body: Center(
        child: Text('Error'),
      ),
    );
  }
}
