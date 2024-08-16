import 'package:isHKolarium/screens/login_screen/login_screen.dart';
import 'package:isHKolarium/screens/splash_screen/splash_screen.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
};
