import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:isHKolarium/constants/colors.dart';
import 'package:isHKolarium/constants/paddings.dart';
import 'package:isHKolarium/constants/strings.dart';
import 'package:isHKolarium/screens/login_screen/login_button.dart';
import 'package:isHKolarium/utils/theme/custom_themes/textfield_theme.dart';
import 'package:isHKolarium/screens/login_screen/login_text_fields.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;

  // Future<void> authenticate(String schoolId, String password) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(
  //           'localhost:3000/api/login'), // Replace with your actual API URL
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'school_id': schoolId,
  //         'password': password,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       // Parse the JSON response if login is successful
  //       Map<String, dynamic> userJson = json.decode(response.body);
  //       String firstName = userJson['first_name'];
  //       String lastName = userJson['last_name'];

  //       print('Welcome, $firstName $lastName');
  //     } else if (response.statusCode == 401) {
  //       print('Invalid school ID or password');
  //     } else {
  //       throw Exception('Failed to load user data');
  //     }
  //   } catch (error) {
  //     print('Server error occurred: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final inputDecorationTheme = isDarkMode
        ? TTextFieldTheme.darkInputDecorationTheme
        : TTextFieldTheme.lightInputDecorationTheme;

    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                SizedBox(height: 35),
                Image.asset(
                  'assets/images/logo_college.png',
                  height: 150.0,
                  width: 150.0,
                ),
                SizedBox(height: defaultPadding / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ScholariumStrings.appTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                SizedBox(height: defaultPadding / 5),
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorPalette.accentBlack
                  : ColorPalette.accentWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(defaultPadding * 1),
                topRight: Radius.circular(defaultPadding * 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildEmailTextField(context, inputDecorationTheme),
                        SizedBox(height: defaultPadding / 1.5),
                        buildPasswordTextField(
                          context,
                          inputDecorationTheme,
                          _passwordVisible,
                          () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        LoginButton(
                          onPress: () {
                            // if (_formKey.currentState!.validate()) {
                            //   go to next screen
                            // }
                            // authenticate('03-2021-01071', 123456);
                          },
                          title: 'Login',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
