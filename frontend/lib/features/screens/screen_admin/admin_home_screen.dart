import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/duty_card.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late AdminBloc adminBloc;
  late BottomNavBloc bottomNavBloc;
  bool isSidebarOpen = true;

  @override
  void initState() {
    super.initState();
    final adminRepository = AdminRepositoryImpl();
    adminBloc = AdminBloc(adminRepository);
    adminBloc.add(FetchDataEvent());
    bottomNavBloc = BottomNavBloc();
  }

  // Dummy duties for the ListView
  List<Duty> dummyDuties = [
    Duty(
        color: ColorPalette.dutyCardColor,
        time: '7:30AM-9:00AM',
        roomName: 'PTC-206'),
    Duty(
        color: ColorPalette.accentDutyCardColor,
        time: '9:00AM-10:30AM',
        roomName: 'PTC-207'),
    Duty(
        color: ColorPalette.accentDutyCardColor,
        time: '10:30AM-12:00PM',
        roomName: 'PTC-208'),
    Duty(
        color: ColorPalette.accentDutyCardColor,
        time: '12:00PM-1:30PM',
        roomName: 'PTC-209'),
  ];

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminBloc>(create: (context) => adminBloc),
        BlocProvider<BottomNavBloc>(create: (context) => bottomNavBloc),
      ],
      child: BlocConsumer<AdminBloc, AdminState>(
        bloc: adminBloc,
        listener: (BuildContext context, AdminState state) {},
        builder: (context, state) {
          if (state is AdminLoadedSuccessState) {
            return AdminScaffold(
              appBar: AppBar(
                title: const Text(
                  "Dashboard",
                  style: TextStyle(fontFamily: 'Manrope', fontSize: 15),
                ),
                backgroundColor: ColorPalette.primary,
                foregroundColor: Colors.white,
              ),
              sideBar: isSidebarOpen
                  ? SideBar(
                      items: [
                        AdminMenuItem(
                          title: 'Dashboard',
                          route: '/',
                          icon: Icons.space_dashboard_rounded,
                        ),
                        AdminMenuItem(
                          title: 'Create Announcement',
                          route: '/announcement',
                          icon: CupertinoIcons.rectangle_stack_fill_badge_plus,
                        ),
                        AdminMenuItem(
                          title: 'Create Schedule',
                          route: '/schedule',
                          icon: CupertinoIcons.calendar_badge_plus,
                        ),
                      ],
                      selectedRoute: '/',
                      onSelected: (item) {
                        if (item.route == '/') {
                          toggleSidebar();
                        } else if (item.route != null) {
                          Navigator.of(context).pushNamed(item.route!);
                        }
                      },
                    )
                  : null,
              body: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F3F4),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.completedSchedulesCount.toString(),
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
                                  state.todaySchedulesCount.toString(),
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
                            const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "60", // Backlogs count from state (You might want to replace this with a dynamic value)
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
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
                      Divider(
                        thickness: 0.4,
                        indent: 20,
                        endIndent: 15,
                        color: Colors.grey[400],
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
                        height: 400,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: dummyDuties.length,
                            itemBuilder: (context, index) {
                              final duty = dummyDuties[index];
                              final textColor =
                                  index == 0 ? Colors.white : Colors.black;

                              return DutyCard(
                                cardColor: duty.color,
                                time: duty.time,
                                roomName: duty.roomName,
                                textColor: textColor,
                              );
                            },
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Status Chart',
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
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 300,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: ColorPalette.accent,
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
                                  color: Colors.grey.withOpacity(0.85),
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
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
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
