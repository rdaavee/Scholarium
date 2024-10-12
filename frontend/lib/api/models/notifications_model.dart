class UserInfo {
  final String? profilePicture;

  const UserInfo({
    required this.profilePicture,
  });

  factory UserInfo.fromJson(Map<String, dynamic> map) {
    return UserInfo(
      profilePicture: map['profile_picture'] as String?,
    );
  }
}

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
  final String profilePicture;

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
    required this.profilePicture,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      id: json['_id'] ?? '',
      sender: json['sender'] ?? '',
      senderName: json['senderName'] ?? '',
      receiver: json['receiver'] ?? '',
      receiverName: json['receiverName'] ?? '',
      role: json['role'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? false,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      profilePicture: json['sender_info'] != null
          ? json['sender_info']['profile_picture'] ?? ''
          : '',
    );
  }
}
