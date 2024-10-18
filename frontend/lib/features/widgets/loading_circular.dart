import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingCircular extends StatelessWidget {
  const LoadingCircular({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animation/loading.json',
        width: 100,
        height: 100,
        fit: BoxFit.fill,
      ),
    );
  }
}
