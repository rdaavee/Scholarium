import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:isHKolarium/api/models/schedule_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/repositories/student_repository.dart';
import 'package:isHKolarium/config/constants/endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentRepositoryImpl extends StudentRepository implements Endpoint {
  int currentYear = DateTime.now().year;
  final String baseUrl = Endpoint().baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Future<Map<String, dynamic>> fetchUpcomingSchedule() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/getUpcomingSchedule'),
      headers: {'Authorization': 'Bearer $token'},
    );

    const emptySchedule = ScheduleModel(
      schoolID: "",
      room: "",
      block: "",
      task: "",
      profID: "",
      professor: "",
      department: "",
      timeIn: "",
      timeOut: "",
      date: "No Upcoming Schedule",
      isCompleted: "",
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final todaySchedules = (data['today'] as List?)
              ?.map((item) => ScheduleModel.fromJson(item))
              .toList() ??
          [];
      final nextSchedule =
          data['next'] != null ? ScheduleModel.fromJson(data['next']) : null;

      return {
        'today': todaySchedules.isEmpty ? [emptySchedule] : todaySchedules,
        'next': nextSchedule ?? emptySchedule,
      };
    } else {
      return {
        'today': [emptySchedule],
        'next': emptySchedule,
      };
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSchedule({
    required String selectedMonth,
  }) async {
    final token = await _getToken();
    final url =
        Uri.parse('$baseUrl/user/getSchedule/$currentYear-$selectedMonth');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load schedule: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching schedule: $e');
      throw Exception('Error fetching schedule: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getScheduleAdmin({
    required String selectedMonth,
    required String schoolId,
  }) async {
    final token = await _getToken();
    final url =
        Uri.parse('$baseUrl/admin/schedule/$currentYear-$selectedMonth');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Filter schedules based on school_id
        final filteredSchedules =
            data.where((item) => item['school_id'] == schoolId).toList();

        // Return the filtered results as a list of maps
        return filteredSchedules
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to load schedule: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching schedule: $e');
      throw Exception('Error fetching schedule: $e');
    }
  }

  @override
  Future<List<DtrModel>> fetchDtrData() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/getDTR'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DtrModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load DTR data');
    }
  }

  @override
  Future<DtrHoursModel> fetchDtrTotalHoursData(String schoolId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/getTotalHours/$schoolId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return DtrHoursModel.fromJson(data);
    } else {
      return const DtrHoursModel(
        totalhours: 0,
        targethours: 10,
      );
    }
  }

  @override
  Future<UserModel> fetchUserData() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      return UserModel(
        schoolID: '',
        email: '',
        firstName: 'N/A',
        middleName: '',
        lastName: '',
        profilePicture: '',
        gender: '',
        contact: '',
        address: '',
        role: '',
        professor: '',
        hkType: '',
        status: '',
        token: '',
      );
    }
  }

  @override
  Future<void> confirmSchedule({required String scheduleId}) async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/user/confirmSchedule/$scheduleId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update schedule: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
