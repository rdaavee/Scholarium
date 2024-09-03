class ScheduleModel {
  final int? id;
  final String? schoolID;
  final String? room;
  final String? block;
  final String? subject;
  final String? profID;
  final String? teacher;
  final String? department;
  final String? time;
  final String? date;
  final String? isCompleted;

  const ScheduleModel({
    this.id,
    required this.schoolID,
    required this.room,
    required this.block,
    required this.subject,
    required this.profID,
    required this.teacher,
    required this.department,
    required this.time,
    required this.date,
    required this.isCompleted,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'] as int?,
      schoolID: map['id'] as String?,
      room: map['roo,'] as String?,
      block: map['block'] as String?,
      subject: map['subject'] as String?,
      profID: map['profID'] as String?,
      teacher: map['teacher'] as String?,
      department: map['department'] as String?,
      time: map['time'] as String?,
      date: map['date'] as String?,
      isCompleted: map['completed'] as String?,
    );
  }
}
