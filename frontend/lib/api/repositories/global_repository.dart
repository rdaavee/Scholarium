import 'package:flutter/material.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';

abstract class GlobalRepository {
  Future<Map<String, dynamic>> loginUser(
      {required String schoolID, required String password});
  Future<void> logout(BuildContext context);
  Future<UserModel> fetchUserData();
  Future<List<AnnouncementModel>> fetchAnnoucementData();
  Future<AnnouncementModel> fetchLatestAnnouncementData();
  Future<List<NotificationsModel>> fetchNotificationsData();
}
