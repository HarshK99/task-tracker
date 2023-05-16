import 'package:flutter/material.dart';
import '../model/task.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.currentTasks,
    required this.prefsKey,
    required this.toggleTaskCompletion,
    required this.removeTask,
  }) : super(key: key);

  final List<Task> currentTasks;
  final String prefsKey;
  final Function toggleTaskCompletion;
  final Function removeTask;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: currentTasks.length,
        itemBuilder: (context, index) {
          final task = currentTasks[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: ListTile(
              tileColor: task.isCompleted ? Colors.grey[200] : null,
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) => toggleTaskCompletion(currentTasks, index, prefsKey),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => removeTask(currentTasks, index, prefsKey),
              ),
            ),
          );
        },
      ),
    );
  }
}

