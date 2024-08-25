import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:isHKolarium/api/models/announcement_model.dart';

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
  //Get Announcement

  Future<List<AnnouncementModel>> fetchAnnoucementData() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/user/getAnnouncements'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AnnouncementModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load annoucement data');
    }
  }
}
