import 'package:flutter/material.dart';
import '../model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../ui/task_list.dart';
import '../ui/task_input.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

class TaskPageContent extends StatefulWidget {
  const TaskPageContent({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<TaskPageContent> createState() => _TaskPageContentState();
}

class _TaskPageContentState extends State<TaskPageContent> {
  List<Task> _newTasks = [];
  List<Task> _dailyTasks = [];
  final TextEditingController _textEditingController = TextEditingController();
  // final FlutterLocalNotificationsPlugin _notificationsPlugin =
  // FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    loadTaskData();
    // initializeNotifications();
    // scheduleDailyReset();
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

  @override
  Widget build(BuildContext context) {
    List<Task> currentTasks =
    widget.currentIndex == 0 ? _newTasks : _dailyTasks;
    String prefsKey = widget.currentIndex == 0 ? 'newTasks' : 'dailyTasks';

    return Column(
      children: [
        TaskList(
          currentTasks: currentTasks,
          prefsKey: prefsKey,
          toggleTaskCompletion: _toggleTaskCompletion,
          removeTask: _removeTask,
        ),
        TaskInputField(
          textEditingController: _textEditingController,
          addTask: () => _addTask(currentTasks, prefsKey),
        ),
      ],
    );
  }
}
