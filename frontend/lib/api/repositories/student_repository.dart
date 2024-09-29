import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';

abstract class StudentRepository {
  Future<Map<String, dynamic>> fetchUpcomingSchedule();
  Future<List<Map<String, dynamic>>> getSchedule(
      {required String selectedMonth});
  Future<DtrHoursModel> fetchDtrTotalHoursData();
  Future<List<DtrModel>> fetchDtrData();
  Future<UserModel> fetchUserData();
}
