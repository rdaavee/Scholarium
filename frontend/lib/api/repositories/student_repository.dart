import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';

abstract class StudentRepository {
  Future<List<DtrModel>> fetchDtrData({ required String? token});
  Future<List<Map<String, dynamic>>> getSchedule({required String token});
  Future<UserModel> fetchStudentData({required String? token});
  Future<DtrHoursModel> fetchDtrTotalHoursData({required String? token});
}
