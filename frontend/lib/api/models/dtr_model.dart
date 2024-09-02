class DtrModel {
  final int? id;
  final String? date;
  final String? timeIn;
  final String? timeOut;
  final int? hoursToRendered;
  final int? hoursRendered;
  final String? teacher;
  final String? teacherSignature;

  const DtrModel({
    this.id,
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.hoursToRendered,
    required this.hoursRendered,
    required this.teacher,
    required this.teacherSignature,
  });

  factory DtrModel.fromJson(Map<String, dynamic> map) {
    return DtrModel(
      id: map['id'] as int?,
      date: map['date'] as String?,
      timeIn: map['time_in'] as String?,
      timeOut: map['time_out'] as String?,
      hoursToRendered: map['hours_to_rendered'] as int?,
      hoursRendered: map['hours_rendered'] as int?,
      teacher: map['teacher'] as String?,
      teacherSignature: map['teacher_signature'] as String?,
    );
  }
}