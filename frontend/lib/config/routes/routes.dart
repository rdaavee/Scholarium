import 'package:isHKolarium/features/screens/screen_login/login_page.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  LoginPage.routeName: (context) => const LoginPage(),
};
