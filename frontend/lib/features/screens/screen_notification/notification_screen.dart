import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_notification/notification_bloc.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/no_data.dart';
import 'package:isHKolarium/features/widgets/notification_widgets/notification_message.dart';
import 'package:isHKolarium/features/widgets/student_widgets/notification_widgets/notification_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/notification_widgets/notification_message.dart';

class NotificationScreen extends StatefulWidget {
  final String isRole;
  const NotificationScreen({super.key, required this.isRole});

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
    context.read<BottomNavBloc>().add(FetchUnreadCountEvent());
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
    return '${months[parsedDate.month - 1]}. ${parsedDate.day}, ${parsedDate.year}';
  }

  String _formatTime(String time) {
    final DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('h:mm a').format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsBloc>(
      create: (context) => notificationsBloc,
      child: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is NotificationsLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is NotificationsLoadedSuccessState) {
            return Scaffold(
              appBar: const AppBarWidget(
                  title: "Notifications", isBackButton: false),
              floatingActionButton: widget.isRole != "Student"
                  ? FloatingActionButton(
                      backgroundColor: ColorPalette.primary.withOpacity(0.6),
                      onPressed: () async {
                        final bool? isCompleted = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.93,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Create User',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: ColorPalette.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Expanded(
                                        child: BlocProvider.value(
                                          value: notificationsBloc,
                                          child:
                                              NotificationCreateMessageWidget(
                                            index: 0,
                                            isRole: "Admin",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );

                        if (isCompleted == true) {
                          // Handle completion if needed
                        } else {
                          print('User creation failed or was canceled.');
                        }
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )
                  : null,
              body: Stack(
                children: [
                  Container(
                    color: ColorPalette.primary.withOpacity(0.6),
                  ),
                  Column(
                    children: [
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
                                final notifications =
                                    state.notifications[index];
                                return GestureDetector(
                                  onTap: () {
                                    notificationsBloc.add(
                                        UpdateNotificationStatusEvent(
                                            notifications.id.toString()));
                                    context
                                        .read<BottomNavBloc>()
                                        .add(FetchUnreadCountEvent());

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .50,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 15),
                                                  Expanded(
                                                    child:
                                                        NotificationMessageWidget(
                                                      sender: notifications
                                                          .sender
                                                          .toString(),
                                                      senderName: notifications
                                                          .senderName
                                                          .toString(),
                                                      receiver: notifications
                                                          .receiver
                                                          .toString(),
                                                      role: notifications.role
                                                          .toString(),
                                                      title: notifications.title
                                                          .toString(),
                                                      message: notifications
                                                          .message
                                                          .toString(),
                                                      status: notifications
                                                          .status
                                                          .toString(),
                                                      date: _formatDate(
                                                          notifications.date
                                                              .toString()),
                                                      time: _formatTime(
                                                          notifications.time
                                                              .toString()),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: NotificationCard(
                                      // Change the background color based on the status
                                      color: notifications.status == false
                                          ? Color.fromARGB(255, 236, 240, 241)
                                          : Color.fromARGB(255, 213, 222,
                                              224), // Replace with your default color
                                      sender: notifications.sender.toString(),
                                      senderName:
                                          notifications.senderName.toString(),
                                      receiver:
                                          notifications.receiver.toString(),
                                      role: notifications.role.toString(),
                                      title: notifications.title.toString(),
                                      message: notifications.message.toString(),
                                      status: notifications.status.toString(),
                                      date: _formatDate(
                                          notifications.date.toString()),
                                      time: _formatTime(
                                          notifications.time.toString()),
                                      profilePicture: "hello"),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is NotificationsErrorState) {
            return Scaffold(
              appBar: const AppBarWidget(
                  title: "Notifications", isBackButton: false),
              body: Stack(
                children: [
                  Container(
                    color: ColorPalette.primary.withOpacity(0.6),
                  ),
                  Center(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F3F4),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: NoData(),
                    ),
                  ),
                ],
              ),
            );
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
