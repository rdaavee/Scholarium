class MessageModel {
  final String sender;
  final String receiver;
  final String content;

  MessageModel(
      {required this.sender, required this.receiver, required this.content});

  factory MessageModel.fromJson(Map<String, dynamic> map) {
    return MessageModel(
      sender: map['sender'] ?? '',
      receiver: map['reciever'] ?? '',
      content: map['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'content': content,
    };
  }
}
