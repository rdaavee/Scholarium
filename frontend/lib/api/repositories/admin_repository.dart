import 'package:isHKolarium/api/models/schedule_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';

abstract class AdminRepository {
  Future<List<UserModel>> fetchAllUsers();
  Future<List<ScheduleModel>> fetchYearSchedule();
  Future<void> createUser(UserModel user);
  Future<void> updateUser(String schoolId, UserModel user);
  Future<void> deleteUser(String schoolId);
  Future<void> createAnnouncement(AnnouncementModel announcement);
  Future<void> updateAnnouncement(String id, AnnouncementModel announcement);
  Future<void> deleteAnnouncement(String id);
}
