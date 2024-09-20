import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_bloc.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_event.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_state.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/student_widgets/schedule_widgets/schedule_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/student_widgets/schedule_widgets/timeline_item.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  late ScheduleBloc scheduleBloc;
  String selectedMonth = 'January';
  final Map<String, int> monthMapping = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'Septemper': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'Septemper',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    final apiService = StudentRepositoryImpl();
    scheduleBloc = ScheduleBloc(apiService);
    _initialize();
  }

  Future<void> _initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    scheduleBloc.add(LoadScheduleEvent(token: token));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScheduleBloc>(
          create: (context) => scheduleBloc,
        )
      ],
      child: BlocConsumer<ScheduleBloc, ScheduleState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: PreferredSize(
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
                    backgroundColor: ColorPalette.accentBlack.withOpacity(0.8),
                    elevation: 0,
                    title: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        "Hi, Ranier",
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
            ),
            body: Stack(
              children: [
                // Background image
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Overlay color
                Container(
                  color: ColorPalette.accentBlack.withOpacity(0.8),
                ),
                // Main content
                Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 30.0, right: 20.0),
                    //   child: Container(
                    //     height: 120.0,
                    //     alignment: Alignment.centerLeft,
                    //     child: const Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           "Schedule",
                    //           style: TextStyle(
                    //             fontSize: 20,
                    //             fontFamily: 'Manrope',
                    //             fontWeight: FontWeight.bold,
                    //             letterSpacing: 1.1,
                    //             color: ColorPalette.accentWhite,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F3F4),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ScheduleDropdown(
                                  selectedMonth: selectedMonth,
                                  months: months,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedMonth = newValue!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: BlocBuilder<ScheduleBloc, ScheduleState>(
                                  bloc: scheduleBloc,
                                  builder: (context, state) {
                                    if (state is ScheduleLoadingState) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (state
                                        is ScheduleLoadedSuccessState) {
                                      final duties = state.schedule;
                                      if (duties.isEmpty) {
                                        return const Center(
                                          child: Text('No schedules available'),
                                        );
                                      }
                                      return ListView.builder(
                                        itemCount: duties.length,
                                        itemBuilder: (context, index) {
                                          final duty =
                                              Map<String, dynamic>.from(
                                                  duties[index]);
                                          final isCompleted =
                                              duty['completed'] == 'true';

                                          return TimelineItem(
                                            duty: duty,
                                            color: isCompleted
                                                ? Colors.green
                                                : Colors.grey,
                                          );
                                        },
                                      );
                                    } else if (state is ScheduleErrorState) {
                                      return Center(
                                        child: Text(
                                            'Failed to load schedule: ${state.message}'),
                                      );
                                    } else {
                                      return const Center(
                                        child: Text('Unexpected state!'),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
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
