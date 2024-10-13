import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/admin_repository_impl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/blocs/bloc_admin/admin_bloc.dart';
import 'package:isHKolarium/blocs/bloc_notification/notification_bloc.dart';

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
    print(widget.scheduleId);
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
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: Card(
              margin: const EdgeInsets.all(10.0),
              elevation: 4.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "From: ${widget.senderName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.date,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[300],
                              fontSize: 10),
                        ),
                        Text(
                          widget.time,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[300],
                              fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.message,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (widget.scheduleId.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(
                              "Accept",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              notificationsBloc.add(
                                  UpdateScheduleStatusEvent(widget.scheduleId));
                              notificationsBloc.add(FetchNotificationsEvent());
                              final notification = NotificationsModel(
                                  sender: "userProfile.schoolID",
                                  senderName: "",
                                  receiverName: "selectedStudent",
                                  title: "Schedule Duty",
                                  role: "Admin",
                                  message: "",
                                  profilePicture: "userProfile.profilePicture");
                              adminBloc
                                  .add(CreateNotificationEvent(notification));
                              Navigator.pop(context, true);
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              "Reject",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        ],
                      )
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
