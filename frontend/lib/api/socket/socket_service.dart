// ignore_for_file: avoid_print

import 'dart:async';
import 'package:isHKolarium/blocs/bloc_bottom_nav/bottom_nav_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  final String socketUrl = "https://scholarium-l8gk.onrender.com";
  // final String socketUrl = "http://localhost:3000";

  final StreamController<dynamic> _messagesController =
      StreamController<dynamic>.broadcast();
  BottomNavBloc? bottomNavBloc;

  factory SocketService() {
    return _instance;
  }

  late IO.Socket chatSocket;
  late IO.Socket notificationSocket;

  Stream<dynamic> get messages => _messagesController.stream;

  SocketService._internal();

  Future<void> connectChatSocket(String userId) async {
    print("Connecting to Chat Socket...");

    // Initialize the chat socket connection
    chatSocket = IO.io('$socketUrl/chat', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    chatSocket.connect();

    await Future.delayed(Duration(seconds: 1));

    chatSocket.onConnect((_) {
      print('Connected to chat namespace');
      chatSocket.emit('registerUser', userId);
    });

    chatSocket.on('receiveMessage', (data) {
      print('New chat message from ${data['sender']}: ${data['content']}');
    });

    chatSocket.onDisconnect((_) {
      print('Disconnected from chat namespace');
    });

    chatSocket.onConnectError((error) {
      print('Connection error: $error');
    });
  }

  Future<void> connectNotificationSocket(String userId) async {
    print("Connecting to Notification Socket...");
    notificationSocket = IO.io('$socketUrl/notifications', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    notificationSocket.connect();

    notificationSocket.onConnect((_) {
      print('Connected to notifications namespace');
      notificationSocket.emit('registerNotificationUser', userId);
    });

    notificationSocket.on('receiveNotification', (notification) {
      if (notification != null) {
        print(
            'New notification: ${notification['title']}, Message: ${notification['message']}');
        _messagesController.add(notification); // Emit the notification
        if (bottomNavBloc != null) {
          bottomNavBloc!.add(BottomNavNewNotificationEvent());
        }
      } else {
        print('Received notification data is null or not in expected format.');
      }
    });

    notificationSocket.onDisconnect((_) {
      print('Disconnected from notifications namespace');
    });

    notificationSocket.onConnectError((error) {
      print('Notification connection error: $error');
    });

    notificationSocket.onError((error) {
      print('Notification socket error: $error');
    });
  }

  void sendMessage(String sender, String receiver, String content) {
    if (chatSocket.connected) {
      chatSocket.emit('sendMessage', {
        'sender': sender,
        'receiver': receiver,
        'content': content,
      });
    } else {
      print('Chat socket is not connected. Unable to send message.');
    }
  }

  void disconnectSockets() {
    if (chatSocket.connected) {
      chatSocket.disconnect();
      print('Disconnected from chat socket');
    }
    if (notificationSocket.connected) {
      notificationSocket.disconnect();
      print('Disconnected from notification socket');
    }
  }

  void dispose() {
    disconnectSockets();
    _messagesController.close();
  }
}
