import 'package:flutter/material.dart';

abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {
  final String token;

  LoadProfileEvent({required this.token});
}

class LogoutEvent extends ProfileEvent {
  final BuildContext context;

  LogoutEvent({required this.context});
}
