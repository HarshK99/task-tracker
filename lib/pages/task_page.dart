import 'package:flutter/material.dart';
import 'task_page_content.dart';

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

  @override
  Widget build(BuildContext context) {
    String pageTitle = _currentIndex == 0 ? 'New Tasks' : 'Daily Tasks';
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: TaskPageContent(
        currentIndex: _currentIndex,
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
            label: 'Daily Tasks',
          ),
        ],
      ),
    );
  }
}
