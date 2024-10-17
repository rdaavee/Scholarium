import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/blocs/bloc_notification/notification_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class NotificationMessageWidget extends StatefulWidget {
  final NotificationsModel notifications;
  const NotificationMessageWidget({
    super.key,
    required this.notifications,
  });

  @override
  NotificationMessageState createState() => NotificationMessageState();
}

class NotificationMessageState extends State<NotificationMessageWidget> {
  late AdminBloc adminBloc;
  late NotificationsBloc notificationsBloc;
  final adminRepository = AdminRepositoryImpl();
  final globalRepository = GlobalRepositoryImpl();
  final studentRepository = StudentRepositoryImpl();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    adminBloc = AdminBloc(adminRepository, globalRepository);
    notificationsBloc = NotificationsBloc(globalRepository, studentRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AdminBloc(adminRepository, globalRepository),
        ),
        BlocProvider(
          create: (context) =>
              NotificationsBloc(globalRepository, studentRepository),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "From: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6D7278),
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: widget.notifications.senderName.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: ColorPalette.accentBlack,
                            fontSize: 15.5,
                            letterSpacing: .8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.notifications.time.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFC1C1C1),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Divider(
                thickness: .09,
                color: ColorPalette.accentBlack,
              ),
              const SizedBox(height: 5.0),
              Text(
                widget.notifications.title.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D7278),
                  fontSize: 18,
                ),
              ),
              Text(
                widget.notifications.message.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              Spacer(),
              if (widget.notifications.scheduleId.toString().isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(150, 60),
                      ),
                      child: const Text(
                        "Accept",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () async {
                        notificationsBloc.add(UpdateScheduleStatusEvent(
                            widget.notifications.scheduleId.toString()));
                        notificationsBloc.add(FetchNotificationsEvent());
                        Navigator.pop(context, true);
                      },
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(150, 60),
                      ),
                      child: const Text(
                        "Reject",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        notificationsBloc.add(DeleteScheduleNotificationEvent(
                            widget.notifications.scheduleId.toString(),
                            widget.notifications.sender.toString()));
                        notificationsBloc.add(FetchNotificationsEvent());
                        Navigator.pop(context, false);
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
