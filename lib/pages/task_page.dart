import 'package:flutter/material.dart';
import '../model/task.dart';


class TaskPage extends StatefulWidget {
  const TaskPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Task> _newTasks = [];
  final List<Task> _dailyTasks = [];
  final TextEditingController _textEditingController = TextEditingController();

  void _addTask(List<Task> taskList) {
    setState(() {
      final newTask = _textEditingController.text;
      if (newTask.isNotEmpty) {
        taskList.add(Task(title: newTask));
        _textEditingController.clear();
      }
    });
  }

  void _removeTask(List<Task> taskList, int index) {
    setState(() {
      taskList.removeAt(index);
    });
  }

  void _toggleTaskCompletion(List<Task> taskList, int index) {
    setState(() {
      taskList[index].isCompleted = !taskList[index].isCompleted;
    });
  }
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    List<Task> currentTasks = _currentIndex == 0 ? _newTasks : _dailyTasks;
    String pageTitle = _currentIndex == 0 ? 'New Tasks' : 'Daily Tasks';

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: currentTasks.length,
              itemBuilder: (context, index) {
                final task = currentTasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) => _toggleTaskCompletion(currentTasks, index),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeTask(currentTasks, index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(hintText: 'Enter task'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTask(currentTasks),
                ),
              ],
            ),
          ),
        ],
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