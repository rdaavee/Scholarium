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
import 'package:isHKolarium/features/widgets/admin_widgets/account_status_card.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/dtr_status_card.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/duty_status_card.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/hk_discount_status_card.dart';
import 'package:isHKolarium/features/widgets/label_text_widget.dart';
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
            style: TextStyle(fontSize: 15),
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
                    icon: CupertinoIcons.rectangle_stack_fill,
                  ),
                  AdminMenuItem(
                    title: 'View Schedule',
                    route: '/view_schedule',
                    icon: CupertinoIcons.calendar,
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
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F3F4),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 23),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: LabelTextWidget(title: 'Account Monitoring'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: [
                                AccountStatusCard(
                                  title: 'Account Status',
                                  activeCount: state.activeCount,
                                  inactiveCount: state.inactiveCount,
                                  cardColor: Colors.green,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                ),
                                HkDiscountStatusCard(
                                  title: 'HK Discounts',
                                  discount25: state.hk25,
                                  discount50: state.hk50,
                                  discount75: state.hk75,
                                  cardColor: Colors.red,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                ),
                                DutyStatusCard(
                                  title: 'Duty Status',
                                  ongoingCount: state.todaySchedulesCount,
                                  completedCount: state.completedSchedulesCount,
                                  cardColor: Colors.orange,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                ),
                                DtrStatusCard(
                                  title: 'DTR Status',
                                  completedCount: state.completedDtr,
                                  cardColor: Colors.purple,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: LabelTextWidget(title: 'Status Chart'),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 270,
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
