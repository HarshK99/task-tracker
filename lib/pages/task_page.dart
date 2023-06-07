import 'package:flutter/material.dart';
import 'task_page_body.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key, required this.title}) : super(key: key);
  final String title;
  //final List<String> titles;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String getPrefsKey() {
    String prefsKey;
    switch (_currentIndex) {
      case 0:
        prefsKey = 'newTasks';
        break;
      case 1:
        prefsKey = 'todayTasks';
        break;
      case 2:
        prefsKey = 'dailyTasks';
        break;
      default:
        prefsKey = '';
    }
    return prefsKey;
  }

  @override
  Widget build(BuildContext context) {
    String pageTitle;
    if (_currentIndex == 0) {
      pageTitle = 'New Tasks';
    } else if (_currentIndex == 1) {
      pageTitle = "Today's Tasks";
    } else {
      pageTitle = 'Daily Tasks';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: TaskPageBody(
        currentIndex: _currentIndex,
        getPrefsKey: getPrefsKey,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_new),
            label: 'New Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: "Today's Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Daily Tasks',
          ),
        ],
      ),
    );
  }
}
