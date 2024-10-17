// schedule_model.dart
import 'package:isHKolarium/api/models/user_model.dart';

class ProfessorScheduleModel {
  final String timeIn;
  final String timeOut;
  final String room;
  final String date;
  final List<UserModel> students;

  ProfessorScheduleModel({
    required this.timeIn,
    required this.timeOut,
    required this.room,
    required this.date,
    required this.students,
  });

  factory ProfessorScheduleModel.fromJson(Map<String, dynamic> json) {
    var studentsJson = json['students'] as List;
    List<UserModel> studentsList = studentsJson.map((i) => UserModel.fromJson(i)).toList();
    return ProfessorScheduleModel(
      timeIn: json['time_in'],
      timeOut: json['time_out'],
      room: json['room'],
      date: json['date'],
      students: studentsList,
    );
  }
}
