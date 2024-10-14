import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/blocs/bloc_notification/notification_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';

class NotificationMessageWidget extends StatefulWidget {
  final String sender;
  final String senderName;
  final String receiver;
  final String role;
  final String title;
  final String message;
  final String status;
  final String scheduleId;
  final String date;
  final String time;
  const NotificationMessageWidget({
    super.key,
    required this.sender,
    required this.senderName,
    required this.receiver,
    required this.role,
    required this.title,
    required this.message,
    required this.status,
    required this.scheduleId,
    required this.date,
    required this.time,
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
    print(widget.sender);
    print(widget.receiver);
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
                            fontFamily: 'Manrope',
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: widget.senderName,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: ColorPalette.accentBlack,
                            fontFamily: 'Manrope',
                            fontSize: 15.5,
                            letterSpacing: .8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFC1C1C1),
                      fontSize: 10,
                      fontFamily: 'Manrope',
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
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D7278),
                  fontFamily: 'Manrope',
                  fontSize: 18,
                ),
              ),
              Text(
                widget.message,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Manrope',
                  fontSize: 13,
                ),
              ),
              Spacer(),
              if (widget.scheduleId.isNotEmpty) ...[
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
                          fontFamily: 'Manrope',
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () async {
                        notificationsBloc
                            .add(UpdateScheduleStatusEvent(widget.scheduleId));
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
                          fontFamily: 'Manrope',
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        notificationsBloc.add(DeleteScheduleNotificationEvent(
                            widget.scheduleId, widget.sender));
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
