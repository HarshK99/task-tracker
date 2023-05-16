import 'package:flutter/material.dart';
import '../model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';





class TaskPage extends StatefulWidget {
  const TaskPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> _newTasks = [];
  List<Task> _dailyTasks = [];
  final TextEditingController _textEditingController = TextEditingController();


  //
  @override
  void initState() {
    super.initState();
    loadTaskData();
  }

  Future<void> loadTaskData() async {
    final newTasks = await loadTaskListFromPrefs('newTasks');
    final dailyTasks = await loadTaskListFromPrefs('dailyTasks');

    setState(() {
      _newTasks = newTasks;
      _dailyTasks = dailyTasks;
    });
  }




  //

  Future<void> _addTask(List<Task> taskList, String key) async {
    final newTask = _textEditingController.text;
    if (newTask.isNotEmpty) {
      setState(() {
        taskList.add(Task(title: newTask));
        _textEditingController.clear();
      });

      // Save the updated task list to shared preferences
      await saveTaskListToPrefs(taskList,key);
    }
  }

  Future<void> _removeTask(List<Task> taskList, int index, String key) async {
    setState(() {
      taskList.removeAt(index);
    });

    // Save the updated task list to shared preferences
    await saveTaskListToPrefs(taskList,key);
  }

  Future<void>  _toggleTaskCompletion(List<Task> taskList, int index, String key) async {
    setState(() {
      taskList[index].isCompleted = !taskList[index].isCompleted;
    });
    await saveTaskListToPrefs(taskList,key);
  }
  //
  Future<void> saveTaskListToPrefs(List<Task> taskList, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = taskList.map((task) => task.toJson()).toList();
    await prefs.setString(key, jsonEncode(taskListJson));
  }



  Future<List<Task>> loadTaskListFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = prefs.getString(key);
    if (taskListJson != null) {
      final taskListData = jsonDecode(taskListJson) as List<dynamic>;
      return taskListData.map((taskData) => Task.fromJson(taskData)).toList();
    } else {
      return [];
    }
  }






  //
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
    String prefsKey =  _currentIndex == 0 ? 'newTasks' : 'dailyTasks';

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
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    tileColor: task.isCompleted ? Colors.grey[200] : null,
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) => _toggleTaskCompletion(currentTasks, index, prefsKey),
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
                      onPressed: () => _removeTask(currentTasks, index, prefsKey),
                    ),
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Text',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _addTask(currentTasks, prefsKey),
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