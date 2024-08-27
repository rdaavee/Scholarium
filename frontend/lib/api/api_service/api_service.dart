import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:isHKolarium/features/login/ui/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000/api';

  //Login
  Future<Map<String, dynamic>> loginUser(
      String schoolID, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'school_id': schoolID,
          'password': password,
        }),
      );

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return {
          'statusCode': response.statusCode,
          'token': responseData['token'],
          'role': responseData['role']
        };
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        return {
          'statusCode': response.statusCode,
          'error': errorResponse['message'] ?? 'Unknown error occurred'
        };
      }
    } catch (e) {
      return {'statusCode': 500, 'error': 'Error: $e'};
    }
  }

  //Users
  //Get all Announcement

  Future<List<AnnouncementModel>> fetchAnnoucementData() async {
    final response =
        await http.get(Uri.parse('$baseUrl/user/getAnnouncements'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AnnouncementModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load annoucement data');
    }
  }

  //Get Latest Announcement
  Future<AnnouncementModel> fetchLatestAnnoucementData() async {
    final response =
        await http.get(Uri.parse('$baseUrl/user/getLatestAnnouncement'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return AnnouncementModel.fromJson(data);
    } else {
      return const AnnouncementModel(
          title: "No Announcements Today", 
          body: "Your future is created by what you do today, not tomorrow.\n — Robert Kiyosaki", 
          time: "", 
          date: ""
        );
    }
  }

  //Get Student Total hours DTR
  Future<DtrHoursModel> fetchDtrTotalHoursData({
    required String? token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/getTotalHours/$token'),
      headers: <String, String>{
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

  Future<Map<String, dynamic>> fetchProfileData(String token) async {
    final url = Uri.parse('$baseUrl/user/profile/$token');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Handle non-200 status codes
        return {};
      }
    } catch (e) {
      // Handle any exceptions
      return {};
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
  }
}
