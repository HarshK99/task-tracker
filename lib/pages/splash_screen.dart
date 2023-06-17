import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Task Tracker",
          style: TextStyle(
            fontSize: 24, // Increase the font size to 24
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
      ),
    );
  }
}
