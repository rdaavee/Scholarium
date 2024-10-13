import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/duty_card.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';

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
    final globalRepository = GlobalRepositoryImpl();
    adminBloc = AdminBloc(adminRepository, globalRepository);
    adminBloc.add(FetchDataEvent());
    bottomNavBloc = BottomNavBloc(globalRepository);
    bottomNavBloc.add(FetchUnreadCountEvent());
  }

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
      child: AdminScaffold(
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
                    title: 'View Announcement',
                    route: '/view_announcement',
                    icon: CupertinoIcons.rectangle_stack_fill_badge_plus,
                  ),
                  AdminMenuItem(
                    title: 'View Schedule',
                    route: '/view_schedule',
                    icon: CupertinoIcons.calendar_badge_plus,
                  ),
                  AdminMenuItem(
                    title: 'Create Announcement',
                    route: '/create_announcement',
                    icon: CupertinoIcons.rectangle_stack_fill_badge_plus,
                  ),
                  AdminMenuItem(
                    title: 'Create Schedule',
                    route: '/create_schedule',
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
        body: BlocConsumer<AdminBloc, AdminState>(
          bloc: adminBloc,
          listener: (BuildContext context, AdminState state) {},
          builder: (context, state) {
            if (state is AdminLoadedSuccessState) {
              return SingleChildScrollView(
                // Ensure this is returned
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F3F4),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
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
                            'Account Monitoring',
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
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Wrap(
                              spacing: 5.0,
                              runSpacing: 5.0,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  child: DutyCard(
                                    cardColor: ColorPalette.accent,
                                    title: 'Account Status',
                                    content:
                                        'Active: ${state.activeCount}\nInactive: ${state.inactiveCount}',
                                    textColor: Colors.black,
                                    icon: CupertinoIcons.person_2_alt,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  child: DutyCard(
                                    cardColor: ColorPalette.dutyCardColor,
                                    title: 'HK Discount\nTypes',
                                    content:
                                        '25%: ${state.hk25}\n50%: ${state.hk50}\n75%: ${state.hk75}',
                                    textColor: Colors.white,
                                    icon: CupertinoIcons.tag_solid,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  child: DutyCard(
                                    cardColor: ColorPalette.dutyCardColor,
                                    title: 'Duties Status',
                                    content:
                                        'Ongoing: ${state.todaySchedulesCount}\nCompleted: ${state.completedSchedulesCount}',
                                    textColor: Colors.white,
                                    icon: CupertinoIcons
                                        .rectangle_fill_on_rectangle_angled_fill,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  child: DutyCard(
                                    cardColor: ColorPalette.accent,
                                    title: 'DTR Status',
                                    content: 'Completed: ${state.completedDtr}',
                                    textColor: Colors.black,
                                    icon:
                                        CupertinoIcons.check_mark_circled_solid,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                                        color: ColorPalette.primary,
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            } else if (state is AdminErrorState) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: LoadingCircular());
            }
          },
        ),
      ),
    );
  }
}
