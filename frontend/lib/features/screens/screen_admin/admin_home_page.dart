import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import for BlocBuilder
import 'package:fl_chart/fl_chart.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/duty_card.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late AdminBloc adminBloc;

  @override
  void initState() {
    super.initState();
    final adminRepository = AdminRepositoryImpl();
    adminBloc = AdminBloc(adminRepository);
    adminBloc.add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Hello, Admin", isBackButton: false),
      backgroundColor: ColorPalette.primary,
      body: BlocBuilder<AdminBloc, AdminState>(
        bloc: adminBloc,
        builder: (context, state) {
          if (state is AdminLoadedState) {
            // Dummy data for counts
            int completedCount = 60; // Dummy completed count
            int ongoingCount = 60; // Dummy ongoing count
            int backlogsCount = 60; // Dummy backlogs count

            // Sample duties for the ListView
            List<Duty> dummyDuties = [
              Duty(
                  color: Color(0xFF549E73),
                  time: '7:30AM-9:00AM',
                  roomName: 'PTC-206'),
              Duty(
                  color: Color(0xFF6DD400),
                  time: '9:00AM-10:30AM',
                  roomName: 'PTC-207'),
              Duty(
                  color: Color(0xFF549E73),
                  time: '10:30AM-12:00PM',
                  roomName: 'PTC-208'),
              Duty(
                  color: Color(0xFF6DD400),
                  time: '12:00PM-1:30PM',
                  roomName: 'PTC-209'),
            ];

            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0F3F4),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$completedCount', // Completed count
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Inter',
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Completed',
                                      style: TextStyle(
                                        color: Color(0xFFC1C1C1),
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$ongoingCount', // Ongoing count
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Inter',
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Ongoing',
                                      style: TextStyle(
                                        color: Color(0xFFC1C1C1),
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$backlogsCount', // Backlogs count
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Inter',
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Backlogs',
                                      style: TextStyle(
                                        color: Color(0xFFC1C1C1),
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 280,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      color: Colors.green,
                                      value: state.activeCount.toDouble(),
                                      title: 'Active',
                                      radius: 120,
                                      titleStyle: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                                    PieChartSectionData(
                                      color: Colors.grey[350],
                                      value: state.inactiveCount.toDouble(),
                                      title: 'Inactive',
                                      radius: 120,
                                      titleStyle: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                                  ],
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Ongoing Duties',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6D7278),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 250,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: dummyDuties.length,
                                itemBuilder: (context, index) {
                                  final duty = dummyDuties[index];
                                  return DutyCard(
                                    cardColor: duty.color,
                                    time: duty.time,
                                    roomName: duty.roomName,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is AdminErrorState) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class Duty {
  final Color color;
  final String time;
  final String roomName;

  Duty({required this.color, required this.time, required this.roomName});
}
