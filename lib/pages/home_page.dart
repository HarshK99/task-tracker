import 'package:flutter/material.dart';
import 'task_page.dart';
import '/ui/task_input_field.dart';
import '../model/task.dart';
import '../db/task_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Task> _tasks = [];
  final TextEditingController _textEditingController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _addTask() async {
    final newTask = _textEditingController.text;
    if (newTask.isNotEmpty) {
      final task = Task(
        id: DateTime.now().microsecondsSinceEpoch,
        title: newTask,
        isCompleted: false,
        dateTime: DateTime.now(),
        description: '',
        parentSection: 'newTasks',
        section: 'New',
      );

      await TaskDatabase.instance.insertTask(task);

      setState(() {
        _textEditingController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Tracker'), // Replace with your app's name
      ),
      body: Column(
        children: [
          Expanded(
            child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem('Tasks', Icons.check_circle, 0),
              _buildNavItem('Calendar', Icons.calendar_today, 1),
              _buildNavItem('Summary', Icons.analytics, 2),
            ],
          ),
          ),
          // Input bar at the bottom
          TaskInputField(
            textEditingController: _textEditingController,
            addTask: _addTask,
          ),
        ],
      ),
    );
  }

  void _navigateToTaskPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage()),
    );
  }

  Widget _buildNavItem(String title, IconData icon, int index) {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle navigation when clicking on elements
        _onItemTapped(index);
        if (title == 'Tasks') {
          _navigateToTaskPage();
        }
      },
      icon: Icon(icon),
      label: Text(title),
    );
  }

  Widget _buildSelectedPage(int index) {
    switch (index) {
      case 0:
        return Container();
      case 1:
      // Implement the calendar page
        return Container(); // Placeholder for the Calendar page
      case 2:
      // Implement the summary page
        return Container(); // Placeholder for the Summary page
      default:
        return Container();
    }
  }
}
