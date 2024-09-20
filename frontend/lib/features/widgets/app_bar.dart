import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_student/students_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

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
          return PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: Stack(
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
                  backgroundColor: ColorPalette.primary.withOpacity(0.6),
                  elevation: 0,
                  title: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
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
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/icons/message.png',
                          width: 27,
                          height: 27,
                          color: ColorPalette.accentWhite,
                        ),
                        onPressed: () {
                          // logic here
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
