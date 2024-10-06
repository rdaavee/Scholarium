import 'package:flutter/material.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/message_model.dart';
import 'dart:async';

import 'package:isHKolarium/config/constants/colors.dart';

class MessageScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String receiverName;

  const MessageScreen({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
  });

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
        backgroundColor: ColorPalette.primary,
        title: Text(
          'Chat with ${widget.receiverName}',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 15,
            letterSpacing: 0.5,
            color: ColorPalette.accentWhite,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorPalette.accentWhite,
            size: 13.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSender = message.sender == widget.senderId;
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isSender
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSender ? 'You' : widget.receiverName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Manrope',
                          fontSize: 10,
                          color: isSender ? Colors.blueAccent : Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isSender ? Colors.blueAccent : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(
                                1,
                                1,
                              ),
                            ),
                          ],
                        ),
                        child: Text(
                          message.content,
                          style: TextStyle(
                              color: isSender ? Colors.white : Colors.black87,
                              fontFamily: 'Manrope',
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: _contentController,
                              decoration: const InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 12,
                                    color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12,
                              ),
                              onSubmitted: (value) {
                                _sendMessage();
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.send, color: Colors.blueAccent),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
