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
  final String? task;
  final String? profID;
  final String? professor;
  final String? department;
  final String? timeIn;
  final String? timeOut;
  final String? date;
  final bool? isActive;
  final String? isCompleted;
  final UserInfo? userInfo; 

  const ScheduleModel(
      {this.id,
      required this.schoolID,
      required this.room,
      required this.block,
      required this.task,
      required this.profID,
      this.professor,
      required this.department,
      required this.timeIn,
      required this.timeOut,
      required this.date,
      this.isActive,
      required this.isCompleted,
      this.userInfo});

  factory ScheduleModel.fromJson(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'] as int?,
      schoolID: map['school_id'] as String?,
      room: map['room'] as String?,
      block: map['block'] as String?,
      task: map['task'] as String?,
      profID: map['prof_id'] as String?,
      professor: map['professor'] as String?,
      department: map['department'] as String?,
      timeIn: map['time_in'] as String?,
      timeOut: map['time_out'] as String?,
      date: map['date'] as String?,
      isActive: map['isActive'] as bool?,
      isCompleted: map['completed'] as String?,
      userInfo: map['user_info'] != null
          ? UserInfo.fromJson(map['user_info'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'school_id': schoolID,
      'room': room,
      'block': block,
      'task': task,
      'prof_id': profID,
      'professor': professor,
      'department': department,
      'time_in': timeIn,
      'time_out': timeOut,
      'date': date,
      'isActive': isActive
    };
  }
}
