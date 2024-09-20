import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_student/students_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70.0);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  late StudentsBloc studentBloc;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final studentRepositoryImpl = StudentRepositoryImpl();
    studentBloc = StudentsBloc(studentRepositoryImpl);
    studentBloc.add(FetchLatestEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => studentBloc,
      child: BlocConsumer<StudentsBloc, StudentsState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/image.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              AppBar(
                leading: null,
                automaticallyImplyLeading: false,
                backgroundColor: ColorPalette.accentBlack.withOpacity(0.8),
                elevation: 0,
                title: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state is StudentsLoadedSuccessState
                            ? "Hi, ${state.users[0].firstName}"
                            : "Hi, User",
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: ColorPalette.accentWhite,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: ColorPalette.accentWhite.withOpacity(0.1),
                        ),
                        child: IconButton(
                          icon: Image.asset(
                            'assets/icons/message.png',
                            width: 25,
                            height: 25,
                            color: ColorPalette.accentWhite,
                          ),
                          onPressed: () {
                            // logic here
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
