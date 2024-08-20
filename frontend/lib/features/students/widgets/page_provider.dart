import 'package:flutter/material.dart';

Widget getPage(int index) {
  switch (index) {
    case 1:
      return Text('Schedule Page');
    case 2:
      return Text('Notification Page');
    case 3:
      return Text('Profile Page');
    default:
      return Text('Home Page');
  }
}
