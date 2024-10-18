import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:isHKolarium/config/routes/routes.dart';
import 'package:isHKolarium/features/screens/screen_login/login_page.dart';
import 'package:isHKolarium/features/screens/screen_onboard/onboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isOnboardCompleted = prefs.getBool('onboard') ?? false;
  runApp(App(isOnboardCompleted: isOnboardCompleted));
}

class App extends StatelessWidget {
  final bool isOnboardCompleted;
  const App({super.key, required this.isOnboardCompleted});

  @override
  Widget build(BuildContext context) {
    String fontFamily = Platform.isIOS ? 'Helvetica' : 'Manrope';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'isHKolarium',
      theme: ThemeData(
        fontFamily: fontFamily,
      ),
      initialRoute:
          isOnboardCompleted ? LoginPage.routeName : OnboardScreen.routeName,
      routes: routes,
    );
  }
}
