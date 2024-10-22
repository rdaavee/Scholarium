import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  late IO.Socket chatSocket;
  late IO.Socket announcementSocket;

  SocketService._internal();

  Future<void> connectChatSocket(String userId) async {
    print("Connect Chat Socket Hit");

    // Initialize the chat socket connection
    chatSocket =
        IO.io('https://scholarium-l8gk.onrender.com/chat', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // Prevent automatic connection
    });

    // Connect to the chat namespace
    chatSocket.connect();

    // Wait for the connection before proceeding
    await Future.delayed(Duration(seconds: 1)); // Ensure socket is connected

    // Listen for connection events
    chatSocket.onConnect((_) {
      print('Connected to chat namespace');
      chatSocket.emit('registerUser', userId); // Register user after connection
    });

    // Listen for incoming messages
    chatSocket.on('receiveMessage', (data) {
      print("hit");
      print('New chat message from ${data['sender']}: ${data['content']}');
    });

    // Listen for disconnection events
    chatSocket.onDisconnect((_) {
      print('Disconnected from chat namespace');
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
      print('Socket is not connected. Unable to send message.');
    }
  }

  void disconnectSockets() {
    chatSocket.disconnect();
    if (announcementSocket != null) {
      announcementSocket.disconnect();
    }
  }
}
