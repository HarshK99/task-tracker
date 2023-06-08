import 'package:flutter/material.dart';
import 'task_page_body.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int _currentParentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentParentIndex = index;
    });
  }

  String getParentSection() {
    String parentSection;
    switch (_currentParentIndex) {
      case 0:
        parentSection = 'newTasks';
        break;
      case 1:
        parentSection = 'todayTasks';
        break;
      case 2:
        parentSection = 'dailyTasks';
        break;
      default:
        parentSection = '';
    }
    return parentSection;
  }

  @override
  Widget build(BuildContext context) {
    String pageTitle;
    if (_currentParentIndex == 0) {
      pageTitle = 'New Tasks';
    } else if (_currentParentIndex == 1) {
      pageTitle = "Today's Tasks";
    } else {
      pageTitle = 'Daily Tasks';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: TaskPageBody(
        currentParentIndex: _currentParentIndex,
        getParentSection: getParentSection(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentParentIndex,
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
