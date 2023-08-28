import 'package:flutter/material.dart';

import '../db/issue_database.dart';
import '../model/issue.dart';

class IssueDetailsBody extends StatefulWidget {
  final Issue issue;

  IssueDetailsBody({Key? key, required this.issue}) : super(key: key);

  @override
  _IssueDetailsBodyState createState() => _IssueDetailsBodyState();
}

class _IssueDetailsBodyState extends State<IssueDetailsBody> {
  bool _isEditing = false;
  late TextEditingController _descriptionController;
  late TextEditingController _storyPointController;
  late TextEditingController _priorityController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.issue.description);
    _storyPointController = TextEditingController(text: widget.issue.storyPoint.toString());
    _priorityController = TextEditingController(text: widget.issue.priority);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _storyPointController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  Future<void> updateIssue(Issue issue) async {
    await IssueDatabase.instance.updateIssue(issue);
    // Perform any additional operations after updating the issue in the database
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _saveChanges();
      }
    });
  }

  void _saveChanges() async {
    final updatedDescription = _descriptionController.text;
    final updatedStoryPoint = int.parse(_storyPointController.text);
    final updatedPriority = _priorityController.text;

    widget.issue.description = updatedDescription;
    widget.issue.storyPoint = updatedStoryPoint;
    widget.issue.priority = updatedPriority;

    await updateIssue(widget.issue);

    _descriptionController.clear();
    _storyPointController.clear();
    _priorityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Title: ${widget.issue.title}',
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
                  widget.issue.description,
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
          if (_isEditing)
            Column(
              children: [
                TextFormField(
                  controller: _storyPointController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Story Point'),
                ),
                TextFormField(
                  controller: _priorityController,
                  decoration: const InputDecoration(labelText: 'Priority'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
