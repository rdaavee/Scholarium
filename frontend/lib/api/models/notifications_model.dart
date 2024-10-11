class NotificationsModel {
  final String? id;
  final String? sender;
  final String? senderName;
  final String? receiver;
  final String? receiverName;
  final String? role;
  final String? title;
  final String? message;
  final bool? status;
  final String? date;
  final String? time;

  const NotificationsModel({
    this.id,
    required this.sender,
    required this.senderName,
    required this.receiver,
    required this.receiverName,
    required this.title,
    required this.role,
    required this.message,
    required this.status,
    required this.date,
    required this.time,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> map) {
    return NotificationsModel(
      id: map['_id'] as String?,
      sender: map['sender'] as String?,
      senderName: map['senderName'] as String?,
      receiver: map['receiver'] as String?,
      receiverName: map['receiverName'] as String?,
      role: map['role'] as String?,
      title: map['title'] as String?,
      message: map['message'] as String?,
      status: map['status'] as bool?,
      time: map['time'] as String?,
      date: map['date'] as String?,
    );
  }
}
