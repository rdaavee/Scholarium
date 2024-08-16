import 'package:flutter/material.dart';
import 'package:isHKolarium/constants/strings.dart';
import 'package:isHKolarium/screens/login_screen/login_screen.dart';

class SplashScreen extends StatelessWidget {
  // Route name for our screen
  static String routeName = 'SplashScreen';

  @override
  Widget build(BuildContext context) {
    //setting duration time using future
    Future.delayed(Duration(seconds: 3), () {
      //splash screen popping once or no returning when the user is on login page kahit mag press back
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    });

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_college.png',
                  width: 150.0,
                  height: 150.0,
                ),
                SizedBox(height: 20.0),
                Text(
                  ScholariumStrings.appTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
