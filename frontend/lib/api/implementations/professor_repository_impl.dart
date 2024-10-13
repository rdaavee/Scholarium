import 'dart:convert';

import 'package:isHKolarium/api/implementations/endpoint.dart';
import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/professor_schedule_model.dart';
import 'package:isHKolarium/api/repositories/professor_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfessorRepositoryImpl extends ProfessorRepository implements Endpoint {
  @override
  final String baseUrl = Endpoint().baseUrl;
  int currentYear = DateTime.now().year;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Future<void> createPost(NotificationsModel notification) async {
    final String? token = await _getToken();
    final url = Uri.parse('http://localhost:3000/api/prof/createPost');

    if (notification.title!.isEmpty || notification.message!.isEmpty) {
      throw Exception('Title and body cannot be empty.');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(notification.toJsonPost()),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<List<ProfessorScheduleModel>> fetchProfTodaySchedule(
      String profId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(
        '$baseUrl/prof/getTodaySchedule/$profId',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> schedulesJson =
          json.decode(response.body)['schedules'];
      return schedulesJson
          .map((json) => ProfessorScheduleModel.fromJson(json))
          .toList();
    } else {
      return [
        ProfessorScheduleModel(
            time: "", room: "No Schedule Today", date: "", students: [])
      ];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSchedule({
    required String selectedMonth,
  }) async {
    final token = await _getToken();
    final url =
        Uri.parse('$baseUrl/prof/getSchedule/$currentYear-$selectedMonth');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(data);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load schedule: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching schedule: $e');
      throw Exception('Error fetching schedule: $e');
    }
  }

  Future<void> updateStudentSchedule(String id) async {
    final token = await _getToken();
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/prof/updateStudentsSchedule/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Handle the response
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Schedule updated successfully: ${responseData['schedule']}');
      } else if (response.statusCode == 404) {
        final responseData = json.decode(response.body);
        print('Error: ${responseData['message']}');
      } else {
        print('Failed to update schedule. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error updating schedule: $error');
    }
  }

  Future<void> createDTR(DtrModel dtrModel) async {
    final token = await _getToken();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/prof/createDTR'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(dtrModel.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print(
            'Attendance record created successfully: ${responseData['record']}');
      } else {
        print(
            'Failed to create attendance record. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error creating attendance record: $error');
    }
  }
}
