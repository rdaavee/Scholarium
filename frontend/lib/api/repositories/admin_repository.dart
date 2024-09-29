import 'package:isHKolarium/api/models/user_model.dart';

abstract class AdminRepository {
  Future<List<UserModel>> fetchAllUsers();
}
