import 'package:flutter/material.dart';
import '../model/task.dart';
import '../ui/task_list.dart';
import '../ui/task_input.dart';
import '../db/task_database.dart';

class TaskPageContent extends StatefulWidget {
  const TaskPageContent({Key? key, required this.currentIndex}) : super(key: key);

  final int currentIndex;

  @override
  State<TaskPageContent> createState() => _TaskPageContentState();
}

class _TaskPageContentState extends State<TaskPageContent> {
  List<Task> _newTasks = [];
  List<Task> _todayTasks = [];
  List<Task> _dailyTasks = [];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTaskData();
  }

  Future<void> loadTaskData() async {
    final newTasks = await TaskDatabase.loadTaskListFromPrefs('newTasks');
    final todayTasks = await TaskDatabase.loadTaskListFromPrefs('todayTasks');
    final dailyTasks = await TaskDatabase.loadTaskListFromPrefs('dailyTasks');

    setState(() {
      _newTasks = newTasks;
      _todayTasks = todayTasks;
      _dailyTasks = dailyTasks;
    });
  }

  Future<void> _addTask(List<Task> taskList, String key) async {
    final newTask = _textEditingController.text;
    if (newTask.isNotEmpty) {
      setState(() {
        taskList.add(Task(title: newTask));
        _textEditingController.clear();
      });

      await TaskDatabase.saveTaskListToPrefs(taskList, key);
    }
  }

  Future<void> _removeTask(List<Task> taskList, int index, String key) async {
    setState(() {
      taskList.removeAt(index);
    });

    await TaskDatabase.saveTaskListToPrefs(taskList, key);
  }

  Future<void> _toggleTaskCompletion(List<Task> taskList, int index, String key) async {
    setState(() {
      taskList[index].isCompleted = !taskList[index].isCompleted;
    });

    await TaskDatabase.saveTaskListToPrefs(taskList, key);
  }

  @override
  Widget build(BuildContext context) {
    List<Task> currentTasks;
    String prefsKey;
    String pageTitle;

    if (widget.currentIndex == 0) {
      currentTasks = _newTasks;
      prefsKey = 'newTasks';
      pageTitle = 'New Tasks';
    } else if (widget.currentIndex == 1) {
      currentTasks = _todayTasks;
      prefsKey = 'todayTasks';
      pageTitle = "Today's Tasks";
    } else {
      currentTasks = _dailyTasks;
      prefsKey = 'dailyTasks';
      pageTitle = 'Daily Tasks';
    }

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
