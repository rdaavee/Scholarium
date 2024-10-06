class UserInfo {
  final String? firstName;
  final String? lastName;

  const UserInfo({
    required this.firstName,
    required this.lastName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> map) {
    return UserInfo(
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
    );
  }
}

class ScheduleModel {
  final int? id;
  final String? schoolID;
  final String? room;
  final String? block;
  final String? subject;
  final String? profID;
  final String? professor;
  final String? department;
  final String? time;
  final String? date;
  final String? isCompleted;
  final UserInfo? userInfo; // Include UserInfo object

  const ScheduleModel(
      {this.id,
      required this.schoolID,
      required this.room,
      required this.block,
      required this.subject,
      required this.profID,
      required this.professor,
      required this.department,
      required this.time,
      required this.date,
      required this.isCompleted,
      this.userInfo});

  factory ScheduleModel.fromJson(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'] as int?,
      schoolID: map['school_id'] as String?,
      room: map['room'] as String?,
      block: map['block'] as String?,
      subject: map['subject'] as String?,
      profID: map['prof_id'] as String?,
      professor: map['professor'] as String?,
      department: map['department'] as String?,
      time: map['time'] as String?,
      date: map['date'] as String?,
      isCompleted: map['completed'] as String?,
      userInfo: map['user_info'] != null
          ? UserInfo.fromJson(map['user_info'] as Map<String, dynamic>)
          : null,
    );
  }
}
