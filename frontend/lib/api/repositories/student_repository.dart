import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';

abstract class StudentRepository {
  Future<Map<String, dynamic>> fetchUpcomingSchedule({required String token});
  Future<List<Map<String, dynamic>>> getSchedule(
      {required String token, required String selectedMonth});
  Future<DtrHoursModel> fetchDtrTotalHoursData({required String? token});
  Future<List<DtrModel>> fetchDtrData({required String? token});
  Future<UserModel> fetchStudentData({required String? token});
}
