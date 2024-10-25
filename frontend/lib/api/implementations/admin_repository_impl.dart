import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:isHKolarium/api/models/event_model.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/schedule_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/repositories/admin_repository.dart';
import 'package:isHKolarium/config/constants/endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRepositoryImpl extends AdminRepository implements Endpoint {
  @override
  final String baseUrl = Endpoint().baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

//-----------------------------------------USER FUNCTION----------------------------------------------------------
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
  Future<List<AnnouncementModel>> fetchAllAnnouncements() async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/getAllAnnouncements');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => AnnouncementModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load dtr: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<int> fetchAllDTRs() async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/getAllDTR');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['exceededCount'];
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<Map<String, int>> fetchCompletedSchedulesByDay() async {
    final String? token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/admin/getUserDutiesCompletedPerWeek'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        Map<String, int> completedSchedules = {
          "Monday": 0,
          "Tuesday": 0,
          "Wednesday": 0,
          "Thursday": 0,
          "Friday": 0,
          "Saturday": 0,
        };

        for (var dayData in data) {
          if (dayData.containsKey('day') && dayData.containsKey('userCount')) {
            completedSchedules[dayData['day']] = dayData['userCount'];
          } else {
            throw Exception(
                "Invalid data format: Missing 'day' or 'userCount'");
          }
        }

        print("Completed schedules: $completedSchedules");

        return completedSchedules;
      } catch (e) {
        print("Error parsing data: $e");
        throw Exception('Failed to parse schedule data');
      }
    } else {
      print("Error response: ${response.statusCode}, ${response.body}");
      throw Exception('Failed to load schedule data');
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

  Future<void> createSchedule(
      ScheduleModel schedule, NotificationsModel notification) async {
    final String? token = await _getToken();
    final url = Uri.parse('$baseUrl/admin/createSchedule');

    final combinedData = {
      'schedule': schedule.toMap(),
      'notification': notification.toMap(),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(combinedData),
      );

      if (response.statusCode == 200) {
        print("Schedule and Notification created successfully");
      } else {
        throw Exception(
            'Failed to create schedule and notification: ${response.statusCode}');
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
        body: json.encode(user.toMap()),
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

//-------------------------------------------ANNOUNCEMENT FUNCTION----------------------------------------------

  @override
  Future<void> createAnnouncement(
      String token, AnnouncementModel announcement) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/createAnnouncement'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(announcement.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create announcement');
    }
  }

  @override
  Future<void> updateAnnouncement(
      String token, AnnouncementModel announcement) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin./updateAnnouncement'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(announcement.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update announcement');
    }
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/admin/deleteAnnouncement'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete announcement');
    }
  }

  Future<EventModel> createEvent(EventModel event, XFile imageFile) async {
    final token = await _getToken();
    final String uploadUrl = '$baseUrl/admin/createEvent';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.fields['event_name'] = event.eventName;
      request.fields['description'] = event.description;
      request.fields['date'] = event.date;
      request.fields['time'] = event.time;

      request.files.add(await http.MultipartFile.fromPath(
        'event_image',
        imageFile.path,
      ));

      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = json.decode(responseData.body);
        return EventModel.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to create event. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error creating event: $error');
    }
  }
}
