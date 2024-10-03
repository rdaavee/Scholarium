import 'package:flutter/cupertino.dart';
import 'package:isHKolarium/features/screens/screen_onboard/onboard_screen.dart';

Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  OnboardScreen.routeName: (context) => const OnboardScreen(),
};
