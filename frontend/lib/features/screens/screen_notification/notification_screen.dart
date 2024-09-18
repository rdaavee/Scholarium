import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/blocs/bloc_notification/notification_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
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
    final apiService = ApiService();
    notificationsBloc = NotificationsBloc(apiService);
    notificationsBloc.add(FetchNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationsBloc>(create: (context) => notificationsBloc)
      ],
      child: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          if (state is NotificationsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationsLoadingState) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is NotificationsLoadedSuccessState) {
            return Scaffold(
              body: Stack(
                children: [
                  // Background image
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/image.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Overlay color
                  Container(
                    color: ColorPalette.primary.withOpacity(0.6),
                  ),
                  // Main content
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 20.0),
                        child: Container(
                          height: 120.0,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Notification",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                  color: ColorPalette.accentWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F3F4),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
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
                                  date: notifications.date.toString(),
                                  time: notifications.time.toString(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
