import 'package:flutter/material.dart';
import 'package:task_tracker/utils/constants.dart';
import 'pages/splash_screen.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: FutureBuilder<void>(
        // future: _navigateToTaskPage(context),
        future: _navigateToHomePage(context),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else {
            // return TaskPage();
            return HomePage();
          }
        },
      ),
    );
  }

  Future<void> _navigateToHomePage(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }
}

