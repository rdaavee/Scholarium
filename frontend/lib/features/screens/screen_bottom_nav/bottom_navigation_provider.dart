import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_student/students_bloc.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/features/widgets/botton_nav/bottom_nav_widget.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/loading_widget.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  late StudentsBloc studentBloc;
  late BottomNavBloc bottomNavBloc;

  @override
  void initState() {
    super.initState();
    final apiService = StudentRepositoryImpl();
    studentBloc = StudentsBloc(apiService);
    bottomNavBloc = BottomNavBloc();
    studentBloc.add(StudentsInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StudentsBloc>(
          create: (context) => studentBloc,
        ),
        BlocProvider<BottomNavBloc>(
          create: (context) => bottomNavBloc,
        ),
      ],
      child: BlocConsumer<StudentsBloc, StudentsState>(
        listener: (context, state) {},
        builder: (context, studentState) {
          if (studentState is StudentsLoadingState) {
            return LoadingWidget();
          } else if (studentState is StudentsLoadedSuccessState) {
            return const BottomNavWidget();
          } else if (studentState is StudentsErrorState) {
            return Scaffold(
              body: Center(child: Text('Error: ${studentState.message}')),
            );
          }
          return const Scaffold(
            body: Center(child: Text('No Data Available')),
          );
        },
      ),
    );
  }
}
