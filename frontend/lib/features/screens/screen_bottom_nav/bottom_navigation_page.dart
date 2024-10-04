import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/blocs/bloc_professor/professors_bloc.dart';
import 'package:isHKolarium/blocs/bloc_student/students_bloc.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/features/widgets/botton_nav/bottom_nav_widget.dart';
import 'package:isHKolarium/features/widgets/authentication_widgets/loading_widget.dart';

class BottomNavigationPage extends StatefulWidget {
  final String isRole;

  const BottomNavigationPage({super.key, required this.isRole});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  late StudentsBloc studentBloc;
  late ProfessorsBloc professorBloc;
  late AdminBloc adminBloc;
  late BottomNavBloc bottomNavBloc;

  @override
  void initState() {
    super.initState();
    if (widget.isRole == "Student") {
      final studentRepositoryImpl = StudentRepositoryImpl();
    final globalRepositoryImpl = GlobalRepositoryImpl();
    studentBloc = StudentsBloc(studentRepositoryImpl, globalRepositoryImpl);
      studentBloc.add(StudentsInitialEvent());
    } else if (widget.isRole == "Professor") {
      professorBloc = ProfessorsBloc();
      professorBloc.add(ProfessorsInitialEvent());
    } else {
      final adminService = AdminRepositoryImpl();
      adminBloc = AdminBloc(adminService);
      adminBloc.add(AdminInitialEvent());
    }
    bottomNavBloc = BottomNavBloc();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        if (widget.isRole == "Student")
          BlocProvider<StudentsBloc>(
            create: (context) => studentBloc,
          ),
        if (widget.isRole == "Professor")
          BlocProvider<ProfessorsBloc>(
            create: (context) => professorBloc,
          ),
        if (widget.isRole == "Admin")
          BlocProvider<AdminBloc>(
            create: (context) => adminBloc,
          ),
        BlocProvider<BottomNavBloc>(
          create: (context) => bottomNavBloc,
        ),
      ],
      child: widget.isRole == "Student"
          ? BlocConsumer<StudentsBloc, StudentsState>(
              listener: (context, state) {},
              builder: (context, studentState) {
                if (studentState is StudentsLoadingState) {
                  return const LoadingWidget();
                } else if (studentState is StudentsLoadedSuccessState) {
                  return const BottomNavWidget(isRole: "Student");
                } else if (studentState is StudentsErrorState) {
                  return Scaffold(
                    body: Center(child: Text('Error: ${studentState.message}')),
                  );
                }
                return const Scaffold(
                  body: Center(child: Text('No Data Available')),
                );
              },
            )
          : widget.isRole == "Professor"
              ? BlocConsumer<ProfessorsBloc, ProfessorsState>(
                  listener: (context, state) {},
                  builder: (context, professorState) {
                    if (professorState is ProfessorsLoadingState) {
                      return const LoadingWidget();
                    } else if (professorState is ProfessorsLoadedSuccessState) {
                      return const BottomNavWidget(isRole: "Professor");
                    } else if (professorState is ProfessorsErrorState) {
                      return Scaffold(
                        body: Center(child: Text('Error: ${professorState.message}')),
                      );
                    }
                    return const Scaffold(
                      body: Center(child: Text('No Data Available')),
                    );
                  },
                )
          : BlocConsumer<AdminBloc, AdminState>(
              listener: (context, state) {},
              builder: (context, adminState) {
                if (adminState is AdminLoadingState) {
                  return const LoadingWidget();
                } else if (adminState is AdminLoadedSuccessState) {
                  return const BottomNavWidget(isRole: "Admin");
                } else if (adminState is AdminErrorState) {
                  return Scaffold(
                    body: Center(child: Text('Error: ${adminState.message}')),
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
