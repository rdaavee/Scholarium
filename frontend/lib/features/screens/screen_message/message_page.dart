import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/message_model.dart';
import 'dart:async'; // Import the async library

class MessageScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;

  const MessageScreen({super.key, required this.senderId, required this.receiverId});

  @override
  MessageScreenState createState() => MessageScreenState();
}

class MessageScreenState extends State<MessageScreen> {
  final GlobalRepositoryImpl messageService = GlobalRepositoryImpl();
  final TextEditingController _contentController = TextEditingController();
  List<MessageModel> messages = [];
  Timer? _timer; 

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _startMessageFetchTimer(); 
  }

  // Fetch messages method
  Future<void> _fetchMessages() async {
    try {
      final fetchedMessages = await messageService.getMessages(widget.senderId, widget.receiverId);
      setState(() {
        messages = fetchedMessages;
      });
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void _startMessageFetchTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchMessages(); 
    });
  }

  Future<void> _sendMessage() async {
    final String content = _contentController.text;

    if (content.isNotEmpty) {
      final message = MessageModel(
        sender: widget.senderId,
        receiver: widget.receiverId,
        content: content,
      );
      await messageService.postMessage(message);

      // Clear the text field
      _contentController.clear();

      // Fetch messages again to include the newly sent message
      _fetchMessages();
    } else {
      print('Message content cannot be empty');
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the screen is disposed
    _contentController.dispose(); // Dispose the text controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.receiverId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text('${message.sender} to ${message.receiver}'),
                  subtitle: Text(message.content),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
