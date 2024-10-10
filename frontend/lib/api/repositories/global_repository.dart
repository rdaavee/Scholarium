import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/password.dart';
import 'package:isHKolarium/api/models/update_password_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';

abstract class GlobalRepository {
  Future<Map<String, dynamic>> loginUser(
      {required String schoolID,
      required String password,
      required String role});
  Future<void> logout(BuildContext context);
  Future<UpdatePasswordModel> updatePassword(
      {required String oldPassword, required String newPassword});
  Future<PasswordModel> forgotPassword({
    required String email,
  });
  Future<PasswordModel> verifyCode({
    required String email,
    required String code,
  });
  Future<PasswordModel> resetPassword({
    required String email,
    required String newPassword,
  });
  Future<UserModel> fetchUserData();
  Future<List<NotificationsModel>> fetchNotificationsData();
  Future<void> updateNotificationStatus(String notificationId);
  Future<List<AnnouncementModel>> fetchAnnoucementData();
  Future<List<AnnouncementModel>> fetchAllAnnouncements();
  Future<AnnouncementModel> fetchLatestAnnouncementData();
  Future<void> uploadProfileImage(File file);
}
