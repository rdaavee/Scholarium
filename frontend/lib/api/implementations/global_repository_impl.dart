import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/event_model.dart';
import 'package:isHKolarium/api/models/message_model.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/password.dart';
import 'package:isHKolarium/api/models/update_password_model.dart';
import 'package:isHKolarium/api/repositories/global_repository.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:isHKolarium/config/constants/endpoint.dart';
import 'package:isHKolarium/features/screens/screen_login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalRepositoryImpl extends GlobalRepository implements Endpoint {
  @override
  final String baseUrl = Endpoint().baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

//-----------------------------------FOR USER AUTHENTICATION ----------------------------------------------------
  @override
  Future<Map<String, dynamic>> loginUser({
    required String schoolID,
    required String password,
    required String role,
    required String status,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'school_id': schoolID,
          'password': password,
          'role': role,
        }),
      );

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return {
          'statusCode': response.statusCode,
          'token': responseData['token'],
          'role': responseData['role'],
          'status': responseData['status'],
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
    await prefs.remove('schoolId');
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

  @override
  Future<PasswordModel> forgotPassword({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgotPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return PasswordModel.fromJson(responseBody);
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Failed to reset password: ${errorBody['message']}');
    }
  }

  @override
  Future<PasswordModel> verifyCode({
    required String email,
    required String code,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verifyCode'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'code': code,
      }),
    );
    print(email);
    print(code);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return PasswordModel.fromJson(responseBody);
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Failed to reset password: ${errorBody['message']}');
    }
  }

  @override
  Future<PasswordModel> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/resetPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return PasswordModel.fromJson(responseBody);
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception('Failed to reset password: ${errorBody['message']}');
    }
  }

//-------------------------------------FOR FETCHING------------------------------------------------------------
  @override
  Future<UserModel> fetchUserProfile() async {
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
  Future<UserModel> fetchUserData(String schoolId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/getUserData/$schoolId'),
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
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/getLatestAnnouncement'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
  Future<List<AnnouncementModel>> fetchAllAnnouncements() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/admin/getAllAnnouncements'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AnnouncementModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load announcements');
    }
  }

  @override
  Future<List<NotificationsModel>> fetchNotificationsData() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/getNotifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) =>
                NotificationsModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load Notifications data');
      }
    } catch (error) {
      print('Error fetching notification: $error'); // Debug print
      throw Exception('Error fetching notification: $error');
    }
  }

  @override
  Future<int> fetchUnreadNotificationCount() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/user/getUnreadNotifications'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        return 0;
      }
    } catch (error) {
      print("Error fetching unread notifications count: $error");
      return 0;
    }
  }

  @override
  Future<void> updateNotificationStatus(String notificationId) async {
    final url =
        Uri.parse('$baseUrl/user/updateNotificationsStatus/$notificationId');

    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'status': 'read',
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Notification updated: ${responseData['notification']}');
      } else if (response.statusCode == 404) {
        print('Notification not found');
      } else {
        print('Failed to update notification: ${response.body}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Future<void> deleteNotificationAndScheduleStatus(
      String scheduleId, String schoolId) async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/deleteSchedule');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'scheduleId': scheduleId,
          'school_id': schoolId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Notification updated: ${responseData['notification']}');
        print(response.statusCode);
      } else {
        print(response.statusCode);
        throw Exception(
            'Failed to delete notification: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      final response = await http.delete(
        Uri.parse('$baseUrl/user/deleteNotification/$notificationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Notification delete: ${responseData['message']}');
      } else if (response.statusCode == 404) {
        print('Notification not found');
      } else {
        print('Failed to update notification: ${response.body}');
      }
    } catch (error) {
      print('Error occurred: $error');
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

      final messages = jsonResponse.map((message) {
        return MessageModel(
          sender: message['sender']['school_id'],
          receiver: message['receiver']['school_id'],
          content: message['content'],
          createdAt: message['createdAt'] != null
              ? DateTime.parse(message['createdAt'])
              : null,
          updatedAt: message['updatedAt'] != null
              ? DateTime.parse(message['updatedAt'])
              : null,
        );
      }).toList();

      messages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

      return messages;
    } else {
      print('Failed to fetch messages: ${response.body}');
      throw Exception('Failed to fetch messages');
    }
  }

  @override
  Future<String> uploadProfileImage(File file) async {
    if (!file.existsSync()) {
      throw Exception('The file does not exist.');
    }
    final token = await _getToken();
    final String uploadUrl = '$baseUrl/user/profile/upload';
    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      request.files.add(await http.MultipartFile.fromPath(
        'profile_picture',
        file.path,
      ));
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = json.decode(responseData.body);
        return jsonResponse.toString();
      } else {
        throw Exception(
            'Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error uploading image: $error');
    }
  }

  @override
  Future<void> createNotification(
      {required NotificationsModel notification}) async {
    final token = await _getToken();
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/admin/createNotification"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(notification.toMap()),
      );

      if (response.statusCode != 200) {
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<EventModel>> fetchEvents() async {
    final token = await _getToken();
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user/fetchEvents"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> events = json.decode(response.body);
        return events.map((event) => EventModel.fromJson(event)).toList();
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching events: $e');
      throw Exception('Error fetching events: $e');
    }
  }
}
