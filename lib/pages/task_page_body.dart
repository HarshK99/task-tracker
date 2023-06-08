import 'package:flutter/material.dart';
import '../model/task.dart';
import '../ui/task_list.dart';
import '../ui/task_input_field.dart';
import '../ui/section_row.dart';
import '../db/task_database.dart';

class TaskPageBody extends StatefulWidget {
  const TaskPageBody({Key? key, required this.currentIndex, required this.getPrefsKey}) : super(key: key);

  final int currentIndex;
  final String Function() getPrefsKey;

  @override
  State<TaskPageBody> createState() => _TaskPageBodyState();
}

class _TaskPageBodyState extends State<TaskPageBody> {
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
    final tasks = await TaskDatabase.instance.loadTasks();
    final sections = await TaskDatabase.instance.loadSections();

    setState(() {
      _tasks = tasks;
      _sections = sections;
    });
  }

  Future<void> _addTask(List<Task> taskList) async {
    final newTask = _textEditingController.text;
    if (newTask.isNotEmpty) {
      final task = Task(
        id: DateTime.now().microsecondsSinceEpoch,
        title: newTask,
        isCompleted: false,
        dateTime: DateTime.now(),
        description: '',
        parentSection: '',
        section: '',
      );

      await TaskDatabase.instance.insertTask(task);

      setState(() {
        taskList.add(task);
        _textEditingController.clear();
      });
    }
  }

  Future<void> _removeTask(List<Task> taskList, int index, String prefsKey) async {
    final task = taskList[index];
    await TaskDatabase.instance.deleteTask(task);

    setState(() {
      taskList.removeAt(index);
    });
  }




  Future<void> _toggleTaskCompletion(List<Task> taskList, int index) async {
    final task = taskList[index];
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      isCompleted: !task.isCompleted,
      dateTime: task.dateTime,
      description: task.description,
      parentSection: task.parentSection,
      section: task.section,
    );

    await TaskDatabase.instance.updateTask(updatedTask);

    setState(() {
      taskList[index] = updatedTask;
    });
  }

  void _addSection(String sectionName) {
    if (sectionName.isNotEmpty) {
      setState(() {
        _sections.add(sectionName);
      });

      TaskDatabase.instance.saveSections(_sections);
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
