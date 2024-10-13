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
  final String? scheduleId;
  final bool? status;
  final String? date;
  final String? time;
  final String? profilePicture;

  const NotificationsModel({
    this.id,
    this.sender,
    this.senderName,
    this.receiver,
    this.receiverName,
    this.title,
    this.role,
    this.message,
    this.scheduleId,
    this.status,
    this.date,
    this.time,
    this.profilePicture,
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
      scheduleId: json['scheduleId'] ?? '',
      status: json['status'] ?? false,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      profilePicture: json['sender_info'] != null
          ? json['sender_info']['profile_picture'] ?? ''
          : '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'sender': sender,
      'senderName': senderName,
      'receiver': receiver,
      'receiverName': receiverName,
      'role': role,
      'title': title,
      'message': message,
      'scheduleId': scheduleId,
      'status': status,
      'date': date,
      'time': time,
      'profile_picture': profilePicture,
    };
  }
}
