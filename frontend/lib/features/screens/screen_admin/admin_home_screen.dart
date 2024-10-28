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
import 'package:isHKolarium/features/widgets/admin_widgets/admin_monitoring.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/dtr_status_card.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/duty_status_card.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/hk_discount_status_card.dart';
import 'package:isHKolarium/features/widgets/admin_widgets/line_graph.dart';
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
                    title: 'Create Announcement',
                    route: '/create_announcement',
                    icon: CupertinoIcons.rectangle_stack_fill_badge_plus,
                  ),
                  AdminMenuItem(
                    title: 'Create Schedule',
                    route: '/create_schedule',
                    icon: CupertinoIcons.calendar_badge_plus,
                  ),
                  AdminMenuItem(
                    title: 'Create Event',
                    route: '/create_event',
                    icon: CupertinoIcons.plus_app_fill,
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
              return Scaffold(
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: LabelTextWidget(
                            title: 'Admin Monitoring',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            AccountStatusCard(
                              title: 'Account Status',
                              activeCount: state.activeCount,
                              inactiveCount: state.inactiveCount,
                              cardColor: ColorPalette.primary,
                            ),
                            HkDiscountStatusCard(
                              title: 'HK Discounts',
                              discount25: state.hk25,
                              discount50: state.hk50,
                              discount75: state.hk75,
                              cardColor: ColorPalette.primary,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: AdminMonitoring(
                          announcementCount: state.announcementsCount,
                          dtrCompletedCount: state.dtrCompletedCount,
                        ),
                      ),
                      SizedBox(
                        height: 360,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 30,
                                horizontal: 20,
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: LabelTextWidget(
                                  title: 'Analytics',
                                ),
                              ),
                            ),
                            LineGraph(completedSchedules: state.graph),
                          ],
                        ),
                      ),
                      // Column(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //         vertical: 30,
                      //         horizontal: 20,
                      //       ),
                      //       child: Align(
                      //         alignment: Alignment.topLeft,
                      //         child: LabelTextWidget(title: 'Status'),
                      //       ),
                      //     ),
                      //     SingleChildScrollView(
                      //       scrollDirection: Axis.horizontal,
                      //       child: Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 10),
                      //         child: Row(
                      //           children: [
                      //             DtrStatusCard(
                      //               title: 'DTR Status',
                      //               completedCount: state.dtrCompletedCount,
                      //               cardColor: Colors.purple,
                      //             ),
                      //             HkDiscountStatusCard(
                      //               title: 'HK Discounts',
                      //               discount25: state.hk25,
                      //               discount50: state.hk50,
                      //               discount75: state.hk75,
                      //               cardColor: Colors.red,
                      //             ),
                      //             DutyStatusCard(
                      //               title: 'Duty Status',
                      //               ongoingCount: state.todaySchedulesCount,
                      //               completedCount:
                      //                   state.completedSchedulesCount,
                      //               cardColor: Colors.orange,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 40,
                      ),
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
