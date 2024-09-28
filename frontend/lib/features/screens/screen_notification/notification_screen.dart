import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_notification/notification_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/student_widgets/notification_widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationsBloc notificationsBloc;

  @override
  void initState() {
    super.initState();
    final apiService = GlobalRepositoryImpl();
    notificationsBloc = NotificationsBloc(apiService);
    notificationsBloc.add(FetchNotificationsEvent());
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final String formattedDate =
        '${months[parsedDate.month - 1]}. ${parsedDate.day}, ${parsedDate.year}';
    return formattedDate;
  }

  String _formatTime(String time) {
    final DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('h:mm a').format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationsBloc>(create: (context) => notificationsBloc)
      ],
      child: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is NotificationsLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is NotificationsLoadedSuccessState) {
            return Scaffold(
              appBar: const AppBarWidget(title: "Notifications", isBackButton: false),
              backgroundColor: ColorPalette.primary.withOpacity(0.6),
              body: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/image.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F3F4),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                          itemCount: state.notifications.length,
                          itemBuilder: (context, index) {
                            final notifications = state.notifications[index];
                            return GestureDetector(
                              onTap: () {
                                // Add your onTap logic here
                              },
                              onLongPress: () {
                                print("Long press");
                              },
                              child: NotificationCard(
                                sender: notifications.sender.toString(),
                                role: notifications.role.toString(),
                                message: notifications.message.toString(),
                                status: notifications.status.toString(),
                                date:
                                    _formatDate(notifications.date.toString()),
                                time:
                                    _formatTime(notifications.time.toString()),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is NotificationsErrorState) {
            return Scaffold(
                appBar: const AppBarWidget(title: "Notifications", isBackButton: false),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/no-data-img.png',
                        height: 230,
                        width: 230,
                      ),
                    ),
                    const Text(
                      'No notification available',
                      style: TextStyle(
                          fontFamily: 'Manrope', fontWeight: FontWeight.bold),
                    ),
                  ],
                ));
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
