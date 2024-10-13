import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/professor_schedule_model.dart';

abstract class ProfessorRepository {
  Future<void> createPost(NotificationsModel notification);
  Future<List<ProfessorScheduleModel>> fetchProfTodaySchedule(String profId);
  Future<List<Map<String, dynamic>>> getSchedule(
      {required String selectedMonth});
}
