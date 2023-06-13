import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/task_logo.png',
          width: 256,
          height: 256,
        ),
      ),
    );
  }
}





