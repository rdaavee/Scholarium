import 'package:isHKolarium/api/models/schedule_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';

abstract class AdminRepository {
  Future<List<UserModel>> fetchAllUsers();
  Future<int> fetchAllDTRs();
  Future<List<AnnouncementModel>> fetchAllAnnouncements();
  Future<Map<String, int>> fetchCompletedSchedulesByDay();
  Future<List<ScheduleModel>> fetchYearSchedule();
  Future<void> createUser(UserModel user);
  Future<void> updateUser(String schoolId, UserModel user);
  Future<void> deleteUser(String schoolId);
  Future<void> createAnnouncement(String token, AnnouncementModel announcement);
  Future<void> updateAnnouncement(String token, AnnouncementModel announcement);
  Future<void> deleteAnnouncement(String id);
}
