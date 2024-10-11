import 'package:isHKolarium/api/models/post_model.dart';
import 'package:isHKolarium/api/models/professor_schedule_model.dart';

abstract class ProfessorRepository {
  Future<void> createPost(PostModel post);
  Future<List<ProfessorScheduleModel>> fetchProfTodaySchedule(String profId);
  Future<List<Map<String, dynamic>>> getSchedule(
      {required String selectedMonth});
}
