import 'package:flutter/material.dart';

abstract class ProfileEvent {}

class ProfileInitialEvent extends ProfileEvent {}
class FetchProfileEvent extends ProfileEvent {}
class LogoutEvent extends ProfileEvent {
  final BuildContext context;

  LogoutEvent({required this.context});
}
