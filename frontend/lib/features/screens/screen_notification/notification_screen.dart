import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:isHKolarium/blocs/bloc_notification/notification_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';
import 'package:isHKolarium/features/widgets/no_data.dart';
import 'package:isHKolarium/features/widgets/notification_widgets/notification_message.dart';
import 'package:isHKolarium/features/widgets/student_widgets/notification_widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  final String isRole;
  const NotificationScreen({super.key, required this.isRole});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationsBloc notificationsBloc;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  // final int _pageSize = 5;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    _scrollController.addListener(_onScroll);
  }

  void _initialize() {
    final globalRepository = GlobalRepositoryImpl();
    final studentRepository = StudentRepositoryImpl();
    notificationsBloc = NotificationsBloc(globalRepository, studentRepository);
    notificationsBloc.add(FetchNotificationsEvent());
    context.read<BottomNavBloc>().add(FetchUnreadCountEvent());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_isFetchingMore) {
        _loadMoreNotifications();
      }
    }
  }

  void _loadMoreNotifications() {
    setState(() {
      _isFetchingMore = true;
    });

    _currentPage++;
    notificationsBloc.add(FetchNotificationsEvent());

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isFetchingMore = false;
      });
    });
  }

  Future<void> _onRefresh() async {
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
      child: Scaffold(
        appBar: const AppBarWidget(
          title: "Notifications",
          isBackButton: false,
        ),
        body: BlocConsumer<NotificationsBloc, NotificationsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is NotificationsLoadingState && _currentPage == 1) {
              return const Center(child: LoadingCircular());
            } else if (state is NotificationsLoadedSuccessState) {
              return RefreshIndicator.adaptive(
                onRefresh: _onRefresh, 
                child: Stack(
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
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: state.notifications.length +
                                  (_isFetchingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == state.notifications.length &&
                                    _isFetchingMore) {
                                  // Show a loading indicator at the bottom while fetching more
                                  return const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }

                                final notification = state.notifications[index];
                                return GestureDetector(
                                  onTap: () async {
                                    context
                                        .read<BottomNavBloc>()
                                        .add(FetchUnreadCountEvent());

                                    bool? result = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 400,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 15),
                                                  Expanded(
                                                    child:
                                                        NotificationMessageWidget(
                                                      sender: notification
                                                          .sender
                                                          .toString(),
                                                      senderName: notification
                                                          .senderName
                                                          .toString(),
                                                      receiver: notification
                                                          .receiver
                                                          .toString(),
                                                      role: notification.role
                                                          .toString(),
                                                      title: notification.title
                                                          .toString(),
                                                      message: notification
                                                          .message
                                                          .toString(),
                                                      status: notification
                                                          .status
                                                          .toString(),
                                                      scheduleId: notification
                                                          .scheduleId
                                                          .toString(),
                                                      date: _formatDate(
                                                          notification.date
                                                              .toString()),
                                                      time: _formatTime(
                                                          notification.time
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
                                    if (result == true) {
                                      _onRefresh();
                                    }
                                    notificationsBloc.add(
                                      UpdateNotificationStatusEvent(
                                          notification.id.toString()),
                                    );
                                  },
                                  child: NotificationCard(
                                    color: notification.status == false
                                        ? const Color(0xFFECEFF1)
                                        : const Color(0xFFD5DEE0),
                                    sender: notification.sender.toString(),
                                    senderName:
                                        notification.senderName.toString(),
                                    receiver: notification.receiver.toString(),
                                    role: notification.role.toString(),
                                    title: notification.title.toString(),
                                    message: notification.message.toString(),
                                    status: notification.status.toString(),
                                    date: _formatDate(
                                        notification.date.toString()),
                                    time: _formatTime(
                                        notification.time.toString()),
                                    profilePicture:
                                        notification.profilePicture.toString(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        if (_isFetchingMore)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                    if (widget.isRole != "Student")
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15, bottom: 15),
                          child: FloatingActionButton(
                            backgroundColor:
                                ColorPalette.primary.withOpacity(0.6),
                            onPressed: () async {
                              // Floating action button logic for adding new notification
                              print('Add notification');
                            },
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else if (state is NotificationsErrorState) {
              return Center(
                child: NoData(
                  title: 'No Notification Available',
                ),
              );
            } else {
              return const Center(child: LoadingCircular());
            }
          },
        ),
      ),
    );
  }
}
