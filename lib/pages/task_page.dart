import 'package:flutter/material.dart';
import 'task_page_body.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

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
      body: SafeArea(
      child:Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: BottomNavigationBar(
              currentIndex: _currentParentIndex,
              onTap: _onTabTapped,
              type: BottomNavigationBarType.fixed,
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
          ),
          Expanded(
            child: TaskPageBody(
              currentParentIndex: _currentParentIndex,
              getParentSection: getParentSection(),
            ),
          ),
        ],
      ),
      )
    );
  }
}
