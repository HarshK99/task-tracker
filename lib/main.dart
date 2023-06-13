import 'package:flutter/material.dart';
import 'package:task_tracker/utils/constants.dart';
import 'pages/task_page.dart';

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
      home: const TaskPage(),
    );
  }
}



