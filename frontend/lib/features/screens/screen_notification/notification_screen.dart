import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
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
  final int _pageSize = 8;
  bool _isFetchingMore = false;
  List<NotificationsModel> _displayedNotifications = [];

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

  void _loadMoreNotifications(List<NotificationsModel> allNotifications) {
    setState(() {
      _isFetchingMore = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final int startIndex = _currentPage * _pageSize;
      final int endIndex = startIndex + _pageSize;
      if (startIndex < allNotifications.length) {
        setState(() {
          _displayedNotifications.addAll(
            allNotifications.sublist(
                startIndex,
                endIndex > allNotifications.length
                    ? allNotifications.length
                    : endIndex),
          );
          _currentPage++;
        });
      }

      setState(() {
        _isFetchingMore = false;
      });
    });
  }

  Future<void> _onRefresh() async {
    _currentPage = 1;
    _displayedNotifications.clear();
    notificationsBloc.add(FetchNotificationsEvent());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_isFetchingMore) {
        final currentState = notificationsBloc.state;
        if (currentState is NotificationsLoadedSuccessState) {
          final allNotifications = currentState.notifications;
          if (_displayedNotifications.length < allNotifications.length) {
            _loadMoreNotifications(allNotifications);
          }
        }
      }
    }
  }

  void _confirmSchedule(String scheduleId) {
    notificationsBloc.add(UpdateScheduleStatusEvent(scheduleId.toString()));
    notificationsBloc.add(FetchNotificationsEvent());
  }

  void _rejectSchedule(String scheduleId, String sender) {
    print("Hellooooo");
    notificationsBloc.add(DeleteScheduleNotificationEvent(
        scheduleId.toString(), sender.toString()));
    notificationsBloc.add(FetchNotificationsEvent());
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _displayedNotifications.removeWhere((n) => n.id == notificationId);
    });
    notificationsBloc.add(DeleteNotificationEvent(notificationId));
    notificationsBloc.add(FetchNotificationsEvent());
    context.read<BottomNavBloc>().add(FetchUnreadCountEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsBloc, NotificationsState>(
      bloc: notificationsBloc,
      listener: (context, state) {
        if (state is NotificationsLoadedSuccessState && _currentPage == 1) {
          setState(() {
            _displayedNotifications =
                state.notifications.take(_pageSize).toList();
          });
        }
      },
      builder: (context, state) {
        if (state is NotificationsLoadingState && _currentPage == 1) {
          return const Center(child: LoadingCircular());
        } else if (state is NotificationsLoadedSuccessState) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const AppBarWidget(
              title: "Notifications",
              isBackButton: false,
            ),
            body: RefreshIndicator.adaptive(
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
                            itemCount: _displayedNotifications.length +
                                (_isFetchingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _displayedNotifications.length &&
                                  _isFetchingMore) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Center(child: LoadingCircular()),
                                );
                              }

                              final notification =
                                  _displayedNotifications[index];
                              return GestureDetector(
                                onTap: () async {
                                  showDialog(
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 15),
                                                Expanded(
                                                  child:
                                                      NotificationMessageWidget(
                                                    notifications: notification,
                                                    confirmFunction:
                                                        (BuildContext) {
                                                      _confirmSchedule(
                                                          notification
                                                              .scheduleId
                                                              .toString());
                                                    },
                                                    rejectFunction:
                                                        (BuildContext) {
                                                      _rejectSchedule(
                                                          notification
                                                              .scheduleId
                                                              .toString(),
                                                          notification.sender
                                                              .toString());
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  notificationsBloc.add(
                                    UpdateNotificationStatusEvent(
                                        notification.id.toString()),
                                  );
                                },
                                child: NotificationCard(
                                  color: notification.status == false
                                      ? const Color(0xFFECEFF1)
                                      : const Color(0xFFD5DEE0),
                                  notifications: notification,
                                  deleteFunction: (BuildContext) {
                                    _deleteNotification(
                                        notification.id.toString());
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.isRole == "")
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, bottom: 15),
                        child: FloatingActionButton(
                          backgroundColor:
                              ColorPalette.primary.withOpacity(0.6),
                          onPressed: () async {
                            print('Add notification');
                          },
                          child: const Text(
                            "Need Faci",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
    );
  }
}
