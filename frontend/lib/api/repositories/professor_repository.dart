import 'package:isHKolarium/api/models/post_model.dart';

abstract class ProfessorRepository {
  Future<void> createPost(PostModel post);
}
