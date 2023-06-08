import 'package:flutter/material.dart';
import '../model/task.dart';
import '../ui/task_list.dart';
import '../ui/task_input_field.dart';
import '../ui/section_row.dart';
import '../db/task_database.dart';

class TaskPageBody extends StatefulWidget {
  const TaskPageBody({Key? key, required this.currentParentIndex, required this.getParentSection}) : super(key: key);

  final int currentParentIndex;
  final String getParentSection;

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
    loadSections().then((_) {
      loadTaskData();
    });
  }

  Future<void> loadSections() async {
    final parentSection = widget.getParentSection; // Get the parent section
    final sections = await TaskDatabase.instance.loadSections(parentSection);
    print("My Sections: $sections");
    setState(() {
      _sections = sections;
    });
  }

  Future<void> loadTaskData() async {
    final parentSection = widget.getParentSection; // Get the parent section
    final section = _sections[_currentSectionIndex]; // Get the section
    final tasks = await TaskDatabase.instance.loadTasksBySections(parentSection, section);

    setState(() {
      _tasks = tasks;
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
        parentSection: widget.getParentSection,
        section: _sections[_currentSectionIndex],
      );

      await TaskDatabase.instance.insertTask(task);

      setState(() {
        taskList.add(task);
        _textEditingController.clear();
      });
    }
  }

  Future<void> _removeTask(List<Task> taskList, int index) async {
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
    final parentSection = widget.getParentSection; // Get the parent section
    if (sectionName.isNotEmpty) {
      setState(() {
        _sections.add(sectionName);
      });

      TaskDatabase.instance.insertSection(parentSection, sectionName);
    }
  }

  void _switchSection(int index) {
    setState(() {
      _currentSectionIndex = index;
      loadTaskData();
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
