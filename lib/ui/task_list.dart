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
    final reversedTasks = currentTasks.reversed.toList();

    return Expanded(
      child: ListView.builder(
        reverse: true, // Reverse the order of the list
        itemCount: reversedTasks.length,
        itemBuilder: (context, index) {
          final task = reversedTasks[index];
          return Dismissible(
            key: Key(task.title),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              removeTask(currentTasks, currentTasks.length - 1 - index, prefsKey);
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListTile(
                tileColor: task.isCompleted ? Colors.grey[200] : null,
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) => toggleTaskCompletion(currentTasks, currentTasks.length - 1 - index, prefsKey),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
