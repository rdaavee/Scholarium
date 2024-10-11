// schedule_model.dart
import 'package:isHKolarium/api/models/user_model.dart';

class ProfessorScheduleModel {
  final String time;
  final String room;
  final String date;
  final List<UserModel> students;

  ProfessorScheduleModel({
    required this.time,
    required this.room,
    required this.date,
    required this.students,
  });

  factory ProfessorScheduleModel.fromJson(Map<String, dynamic> json) {
    var studentsJson = json['students'] as List;
    List<UserModel> studentsList = studentsJson.map((i) => UserModel.fromJson(i)).toList();
    return ProfessorScheduleModel(
      time: json['time'],
      room: json['room'],
      date: json['date'],
      students: studentsList,
    );
  }
}
