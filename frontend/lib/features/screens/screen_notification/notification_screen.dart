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
            return const Scaffold(
              backgroundColor: ColorPalette.accent,
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is NotificationsLoadedSuccessState) {
            return Scaffold(
              backgroundColor: ColorPalette.primary,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 20.0),
                    child: Container(
                      height: 100.0,
                      color: ColorPalette.primary,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Notification",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              color: ColorPalette.accentWhite,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.message,
                              color: ColorPalette.accentWhite,
                            ),
                            onPressed: () {
                              //logic here
                            },
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
                          return NotificationCard(
                            sender: notifications.sender.toString(),
                            role: notifications.role.toString(),
                            message: notifications.message.toString(),
                            status: notifications.status.toString(),
                            date: notifications.date.toString(),
                            time: notifications.time.toString(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
