import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:isHKolarium/api/models/schedule_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/repositories/admin_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRepositoryImpl extends AdminRepository {
  final String baseUrl = 'http://localhost:3000/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Future<List<UserModel>> fetchAllUsers() async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/listUsers');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<List<ScheduleModel>> fetchYearSchedule() async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/getYearSched');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => ScheduleModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load schdule: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> createUser(UserModel user) async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/insertUser');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(user.toMap()), // Use toMap to convert to JSON
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> updateUser(String schoolId, UserModel user) async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/updateUser/$schoolId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(user.toMap()), // Use toMap to convert to JSON
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> deleteUser(String schoolId) async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/deleteUser/$schoolId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/announce');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(announcement.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to create announcement: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> updateAnnouncement(
      String id, AnnouncementModel announcement) async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/updateAnnounce/$id');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(announcement.toJson()), // Adjusted to call toJson
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update announcement: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/deleteAnnounce/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete announcement: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
