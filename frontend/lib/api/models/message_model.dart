class MessageModel {
  final String sender;
  final String receiver;
  final String content;
  final DateTime? createdAt; 
  final DateTime? updatedAt; 

  MessageModel({
    required this.sender,
    required this.receiver,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> map) {
    return MessageModel(
      sender: map['sender'] ?? '',
      receiver: map['receiver'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null, 
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
