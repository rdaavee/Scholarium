import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/schedule_model.dart';
import 'package:isHKolarium/api/models/update_password_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/repositories/global_repository.dart';
import 'package:isHKolarium/api/repositories/student_repository.dart';
import 'package:http/http.dart' as http;
import 'package:isHKolarium/features/screens/screen_login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentRepositoryImpl implements StudentRepository, GlobalRepository {
  int currentYear = DateTime.now().year;
  final String baseUrl = 'http://localhost:3000/api'; //localhost
  // final String baseUrl = 'http://192.168.4.181:3000/api'; //usb tethering

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
      subject: "",
      profID: "",
      professor: "",
      department: "",
      time: "",
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
  Future<DtrHoursModel> fetchDtrTotalHoursData() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/getTotalHours'),
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
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
  }

  Future<UpdatePasswordModel> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/user/updatePassword'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      return UpdatePasswordModel.fromJson(jsonDecode(response.body));
    } else {
      return UpdatePasswordModel(
        success: false,
        message: 'Failed to update password',
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
        role: '',
        gender: '',
        contact: '',
        address: '',
        hkType: '',
        status: '',
        token: '',
      );
    }
  }

  @override
  Future<List<AnnouncementModel>> fetchAnnoucementData() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/getAnnouncements'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AnnouncementModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load announcement data');
    }
  }

  @override
  Future<AnnouncementModel> fetchLatestAnnouncementData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/getLatestAnnouncement'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return AnnouncementModel.fromJson(data);
    } else {
      return const AnnouncementModel(
        title: "No Announcements Today",
        body:
            "Your future is created by what you do today, not tomorrow.\n — Robert Kiyosaki",
        time: "",
        date: "",
      );
    }
  }

  @override
  Future<List<NotificationsModel>> fetchNotificationsData() async {
    final token = await _getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/getNotifications'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => NotificationsModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Notifications data');
      }
    } catch (error) {
      print('Error fetching notification: $error'); // Debug print
      throw Exception('Error fetching notification: $error');
    }
  }

  @override
  Future<Map<String, dynamic>> loginUser(
      {required String schoolID, required String password}) {
    throw UnimplementedError();
  }
}
