import 'dart:convert';

import 'package:isHKolarium/api/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:isHKolarium/api/repositories/admin_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRepositoryImpl extends AdminRepository {
  final String baseUrl = 'http://localhost:3000/api';

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
      print(response.statusCode);
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

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
