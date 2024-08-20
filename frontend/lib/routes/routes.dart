import 'package:isHKolarium/features/login/ui/login_page.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  LoginPage.routeName: (context) => LoginPage(),
};
