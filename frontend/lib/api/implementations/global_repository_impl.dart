import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/message_model.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/update_password_model.dart';
import 'package:isHKolarium/api/repositories/global_repository.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:isHKolarium/features/screens/screen_login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalRepositoryImpl implements GlobalRepository {
  final String baseUrl = 'http://localhost:3000/api'; //localhost
  // final String baseUrl = 'http://192.168.4.181:3000/api'; //usb tethering

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

//-----------------------------------FOR USER AUTHENTICATION ----------------------------------------------------
  @override
  Future<Map<String, dynamic>> loginUser({
    required String schoolID,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

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
          'role': responseData['role'],
        };
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        return {
          'statusCode': response.statusCode,
          'error': errorResponse['message'] ?? 'Unknown error occurred',
        };
      }
    } catch (e) {
      print('Error logging in: $e');
      return {'statusCode': 500, 'error': 'Error: $e'};
    }
  }

  @override
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('login');
    await prefs.remove('schooldId');
    await prefs.remove('password');

    Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
  }

  @override
  Future<UpdatePasswordModel> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/user/updatePassword'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return UpdatePasswordModel(
        success: true,
        message: 'Successfully updated password',
      );
    } else {
      return UpdatePasswordModel(
        success: false,
        message: 'Failed to update password',
      );
    }
  }

//-------------------------------------FOR FETCHING------------------------------------------------------------
  @override
  Future<UserModel> fetchUserData() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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
    } catch (error) {
      print('Error fetching user data: $error'); // Debug print
      throw Exception('Error fetching user data: $error');
    }
  }

  @override
  Future<AnnouncementModel> fetchLatestAnnouncementData() async {
    final response =
        await http.get(Uri.parse('$baseUrl/user/getLatestAnnouncement'));

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
    try {
      final token =
          await _getToken(); // Retrieve token using the _getToken method
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/getNotifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Add the token in the Authorization header
        },
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
  Future<List<AnnouncementModel>> fetchAnnoucementData() {
    throw UnimplementedError();
  }

  //-------------------------------------FOR MESSAGING SYSTEM------------------------------------------------------------

  Future<void> postMessage(MessageModel message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/postMessage'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(message.toJson()),
    );

    if (response.statusCode == 200) {
      print('Message sent successfully!');
    } else {
      print('Failed to send message: ${response.body}');
      throw Exception('Failed to send message');
    }
  }

  Future<List<MessageModel>> getMessages(
      String senderId, String receiverId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/getMessages/$senderId/$receiverId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((message) => MessageModel(
                sender: message['sender']['school_id'],
                receiver: message['receiver']['school_id'],
                content: message['content'],
              ))
          .toList();
    } else {
      print('Failed to fetch messages: ${response.body}');
      throw Exception('Failed to fetch messages');
    }
  }
}
