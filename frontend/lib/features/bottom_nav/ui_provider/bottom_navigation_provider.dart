import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/features/students/bloc/students_bloc.dart';
import 'package:isHKolarium/features/bottom_nav/bloc/bottom_nav_bloc.dart';
import 'package:isHKolarium/features/students/widgets/bottom_nav_widget.dart';
import 'package:isHKolarium/features/students/widgets/loading_widget.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';

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
    final apiService = ApiService(); 
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
        listener: (context, state) {
        },
        builder: (context, studentState) {
          if (studentState is StudentsLoadingState) {
            return LoadingWidget();
          } else if (studentState is StudentsLoadedSuccessState) {
            return BottomNavWidget();
          } else if (studentState is StudentsErrorState) {
            return Scaffold(
              body: Center(child: Text('Error: ${studentState.message}')),
            );
          }
          return Scaffold(
            body: Center(child: Text('No Data Available')),
          );
        },
      ),
    );
  }
}

