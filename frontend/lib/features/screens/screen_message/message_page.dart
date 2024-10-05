import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/message_model.dart';
import 'dart:async'; // Import the async library

class MessageScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String receiverName;

  const MessageScreen(
      {super.key,
      required this.senderId,
      required this.receiverId,
      required this.receiverName});

  @override
  MessageScreenState createState() => MessageScreenState();
}

class MessageScreenState extends State<MessageScreen> {
  final GlobalRepositoryImpl messageService = GlobalRepositoryImpl();
  final TextEditingController _contentController = TextEditingController();
  List<MessageModel> messages = [];
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _startMessageFetchTimer();
  }

  Future<void> _fetchMessages() async {
    try {
      final fetchedMessages =
          await messageService.getMessages(widget.senderId, widget.receiverId);
      if (mounted) {
        setState(() {
          messages = fetchedMessages;
        });
        // Scroll to the bottom after fetching messages
        _scrollToBottom();
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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

      _contentController.clear();

      // Fetch messages after sending and scroll to the bottom
      await _fetchMessages();
      _scrollToBottom();
    } else {
      print('Message content cannot be empty');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.receiverName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.sender == widget.senderId
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      crossAxisAlignment: message.sender == widget.senderId
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.sender == widget.senderId
                              ? 'You'
                              : widget.receiverName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: message.sender == widget.senderId
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: message.sender == widget.senderId
                                ? Colors.blue[100] // Background color for "You"
                                : Colors.grey[300], // Background color for receiver
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(message.content),
                        ),
                      ],
                    ),
                  ),
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
                    decoration: const InputDecoration(
                      labelText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _sendMessage();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
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
