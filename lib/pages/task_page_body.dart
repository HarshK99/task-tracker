import 'package:flutter/material.dart';
import '../model/task.dart';
import '../ui/task_list.dart';
import '../ui/task_input_bar.dart';
import '../ui/section_row.dart';
import '../db/task_database.dart';

class TaskPageContent extends StatefulWidget {
  const TaskPageContent({Key? key, required this.currentIndex, required this.getPrefsKey}) : super(key: key);

  final int currentIndex;
  final String Function() getPrefsKey;

  @override
  State<TaskPageContent> createState() => _TaskPageContentState();
}

class _TaskPageContentState extends State<TaskPageContent> {
  List<Task> _tasks = [];
  List<String> _sections = [];
  int _currentSectionIndex = 0;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTaskData();
  }

  Future<void> loadTaskData() async {
    final tasks = await TaskDatabase.loadTaskListFromPrefs(widget.getPrefsKey());
    final sections = await TaskDatabase.loadTaskSectionsFromPrefs();

    setState(() {
      _tasks = tasks;
      _sections = sections;
    });
  }

  Future<void> _addTask(List<Task> taskList) async {
    final newTask = _textEditingController.text;
    if (newTask.isNotEmpty) {
      setState(() {
        taskList.add(Task(title: newTask));
        _textEditingController.clear();
      });

      await TaskDatabase.saveTaskListToPrefs(taskList, widget.getPrefsKey());
    }
  }

  Future<void> _removeTask(List<Task> taskList, int index) async {
    setState(() {
      taskList.removeAt(index);
    });

    await TaskDatabase.saveTaskListToPrefs(taskList, widget.getPrefsKey());
  }

  Future<void> _toggleTaskCompletion(List<Task> taskList, int index) async {
    setState(() {
      taskList[index].isCompleted = !taskList[index].isCompleted;
    });

    await TaskDatabase.saveTaskListToPrefs(taskList, widget.getPrefsKey());
  }

  void _addSection(String sectionName) {
    if (sectionName.isNotEmpty) {
      setState(() {
        _sections.add(sectionName);
      });

      TaskDatabase.saveTaskSectionsToPrefs(_sections);
    }
  }

  void _switchSection(int index) {
    setState(() {
      _currentSectionIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    List<Task> currentTasks = _tasks;

    return Column(
      children: <Widget>[
        SectionRow(
          sections: _sections,
          currentSectionIndex: _currentSectionIndex,
          addSection: _addSection,
          switchSection: _switchSection,
        ),
        TaskList(
          currentTasks: currentTasks,
          prefsKey: '${widget.getPrefsKey()}$_currentSectionIndex',
          toggleTaskCompletion: _toggleTaskCompletion,
          removeTask: _removeTask,
        ),
        TaskInputField(
          textEditingController: _textEditingController,
          addTask: () => _addTask(currentTasks),
        ),
      ],
    );
  }
}
