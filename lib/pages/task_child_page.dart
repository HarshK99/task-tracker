import 'package:flutter/material.dart';
import '../model/task.dart';
import '../db/task_database.dart';
import '../ui/task_list.dart';
import '../ui/task_input_field.dart';
import 'task_details_page.dart';

class TaskChildPage extends StatefulWidget {
  final Task parentTask;

  TaskChildPage({super.key, required this.parentTask});

  @override
  _TaskChildPageState createState() => _TaskChildPageState();
}

class _TaskChildPageState extends State<TaskChildPage> {
  List<Task> _childTasks = [];
  final TextEditingController _textEditingController = TextEditingController();


  @override
  void initState() {
    super.initState();
    loadChildTasks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadChildTasks();
  }


  Future<void> loadChildTasks() async {
    final parentTask = widget.parentTask;
    final childTasks = await TaskDatabase.instance.loadChildTasks(parentTask.id);
    print("LoadChildTasks");

    setState(() {
      _childTasks = childTasks;
    });
  }

  Future<void> _addChildTask() async {
    final newTask = _textEditingController.text;
    if (newTask.isNotEmpty) {
      final childTask = Task(
        id: DateTime.now().microsecondsSinceEpoch,
        title: newTask,
        isCompleted: false,
        dateTime: DateTime.now(),
        description: '',
        parentId: widget.parentTask.id,
      );

      await TaskDatabase.instance.insertTask(childTask);

      setState(() {
        _childTasks.add(childTask);
        _textEditingController.clear();
      });
    }
  }

  Future<void> _removeChildTask(int index) async {
    final childTask = _childTasks[index];
    await TaskDatabase.instance.deleteTask(childTask);

    setState(() {
      _childTasks.removeAt(index);
    });
  }

  Future<void> _toggleChildTaskCompletion(int index) async {
    final childTask = _childTasks[index];
    final updatedChildTask = Task(
      id: childTask.id,
      title: childTask.title,
      isCompleted: !childTask.isCompleted,
      dateTime: childTask.dateTime,
      description: childTask.description,
      parentId: childTask.parentId,
    );

    await TaskDatabase.instance.updateTask(updatedChildTask);

    setState(() {
      _childTasks[index] = updatedChildTask;
    });
  }

  void _handleTaskLongPress(Task task) async{
    final parentTask = widget.parentTask;

    // Update the parentSection to 'Today'
    final updatedTask = task.copyWith(parentSection: "todayTasks",section: parentTask.section);
    print('Long pressed task: ${updatedTask.title},${updatedTask.parentSection},${updatedTask.section}');
    await TaskDatabase.instance.updateTask(updatedTask);


    setState(() {
    });
  }

  Future<void> _navigateToTaskDetails(BuildContext context, Task task) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TaskDetailsPage(task: task)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Tasks'),
      ),
      body: Column(
        children: [
          TaskList(
            currentTasks: _childTasks,
            toggleTaskCompletion: _toggleChildTaskCompletion,
            removeTask: _removeChildTask,
            viewTaskDetails: (task) => _navigateToTaskDetails(context, task),
            onTaskLongPress: _handleTaskLongPress,
          ),
          TaskInputField(
            textEditingController: _textEditingController,
            addTask: _addChildTask,
          ),
        ],
      ),
    );
  }
}
