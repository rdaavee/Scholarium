import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'isHKolarium',
      // themeMode: ThemeMode.system,
      // theme: TAppTheme.lightTheme,
      // darkTheme: TAppTheme.darkTheme,
      //initial is the first screen to pop up when u open the app
      // initialRoute: LoginPage.routeName,
      initialRoute:
          isOnboardCompleted ? LoginPage.routeName : OnboardScreen.routeName,
      //defined the routes file here in order to access the routes any where all over the app
      routes: routes,
    );
  }
}
