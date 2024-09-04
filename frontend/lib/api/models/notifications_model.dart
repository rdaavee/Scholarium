class NotificationsModel {
  final int? id;
  final String? schoolID;
  final String? sender;
  final String? role;
  final String? message;
  final String? status;
  final String? date;
  final String? time;

  const NotificationsModel({
    this.id,
    required this.schoolID,
    required this.sender,
    required this.role,
    required this.message,
    required this.status,
    required this.date,
    required this.time,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> map) {
    return NotificationsModel(
      id: map['id'] as int?,
      schoolID: map['school_id'] as String?,
      sender: map['sender'] as String?,
      role: map['role'] as String?,
      message: map['message'] as String?,
      status: map['status'] as String?,
      time: map['time'] as String?,
      date: map['date'] as String?,
    );
  }
}
