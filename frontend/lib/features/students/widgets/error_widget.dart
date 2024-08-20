import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final String message;

  const ErrorWidget({super.key, this.message = 'Error'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}
