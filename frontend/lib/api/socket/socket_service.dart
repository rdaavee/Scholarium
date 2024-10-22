import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  late IO.Socket chatSocket;
  late IO.Socket announcementSocket;

  SocketService._internal();

  void connectChatSocket() {
    print("Connect Chat Socket Hit");
    chatSocket = IO.io('http://localhost:3000/chat', <String, dynamic>{
      'transports': ['websocket'],
    });

    chatSocket.onConnect((_) {
      print('Connected to chat namespace');
    });

    chatSocket.on('receiveMessage', (data) {
      print('New chat message from ${data['sender']}: ${data['content']}');
    });

    chatSocket.onDisconnect((_) {
      print('Disconnected from chat namespace');
    });
  }

  void connectAnnouncementSocket() {
    announcementSocket =
        IO.io('http://<your-server-ip>:3000/announcements', <String, dynamic>{
      'transports': ['websocket'],
    });

    announcementSocket.onConnect((_) {
      print('Connected to announcements namespace');
    });

    announcementSocket.on('newAnnouncement', (data) {
      print('New announcement: ${data['message']}');
    });

    announcementSocket.onDisconnect((_) {
      print('Disconnected from announcements namespace');
    });
  }

  void sendMessage(String sender, String receiver, String content) {
    chatSocket.emit('sendMessage', {
      'sender': sender,
      'receiver': receiver,
      'content': content,
    });
  }

  void sendAnnouncement(String message, String department) {
    announcementSocket.emit('sendAnnouncement', {
      'message': message,
      'department': department,
    });
  }

  void disconnectSockets() {
    chatSocket.disconnect();
    announcementSocket.disconnect();
  }
}
