import 'package:flutter/material.dart';


class TaskInputField extends StatelessWidget {
  const TaskInputField({
    Key? key,
    required this.textEditingController,
    required this.addTask,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final void Function() addTask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: 'Enter Task',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: addTask,
          ),
        ],
      ),
    );
  }
}
