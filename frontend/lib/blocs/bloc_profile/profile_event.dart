import 'package:flutter/material.dart';

abstract class ProfileEvent {}

class ProfileInitialEvent extends ProfileEvent {}

class FetchProfileEvent extends ProfileEvent {}

class FetchUserDataEvent extends ProfileEvent {
  final String schoolId;

  FetchUserDataEvent({required this.schoolId});
}

class LogoutEvent extends ProfileEvent {
  final BuildContext context;

  LogoutEvent({required this.context});
}

class PickImageEvent extends ProfileEvent {
  final String imagePath;

  PickImageEvent(this.imagePath);
}
