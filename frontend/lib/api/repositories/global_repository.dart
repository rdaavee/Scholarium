import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isHKolarium/api/models/announcement_model.dart';
import 'package:isHKolarium/api/models/notifications_model.dart';
import 'package:isHKolarium/api/models/password.dart';
import 'package:isHKolarium/api/models/update_password_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';

abstract class GlobalRepository {
  Future<Map<String, dynamic>> loginUser({
    required String schoolID,
    required String password,
    required String role,
    required String status,
  });
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
  Future<UserModel> fetchUserProfile();
  Future<UserModel> fetchUserData(String schoolId);
  Future<List<NotificationsModel>> fetchNotificationsData();
  Future<int> fetchUnreadNotificationCount();
  Future<void> createNotification({required NotificationsModel notification});
  Future<void> updateNotificationStatus(String notificationId);
  Future<void> deleteNotificationAndScheduleStatus(
      String scheduleId, String schoolId);
  Future<void> deleteNotification(String notificationId);
  Future<List<AnnouncementModel>> fetchAnnoucementData();
  Future<List<AnnouncementModel>> fetchAllAnnouncements();
  Future<AnnouncementModel> fetchLatestAnnouncementData();
  Future<void> uploadProfileImage(File file);
}
