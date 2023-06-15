import 'package:flutter/material.dart';
import '../model/task.dart';
import '../db/task_database.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  TaskDetailsPage({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  bool _isEditing = false;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> updateTask(Task task) async {
    await TaskDatabase.instance.updateTask(task);
    // Perform any additional operations after updating the task in the database
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Save the updated description when editing is finished
        _saveDescription();
      }
    });
  }

  void _saveDescription() async {
    final updatedDescription = _descriptionController.text;
    widget.task.description = updatedDescription;

    await updateTask(widget.task);

    // Clear the input field
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${widget.task.title}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _isEditing
                      ? TextField(
                    controller: _descriptionController,
                    maxLines: null,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a description',
                    ),
                  )
                      : Text(
                    widget.task.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isEditing ? Icons.done : Icons.edit,
                    size: 20,
                  ),
                  onPressed: _toggleEditing,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
