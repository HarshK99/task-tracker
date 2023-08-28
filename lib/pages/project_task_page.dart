import 'package:flutter/material.dart';
import 'package:task_tracker/ui/issue_child_body.dart';
import '../model/issue.dart';
import '../ui/issue_details_body.dart';

class ProjectTasksPage extends StatefulWidget {
  final Issue parentIssue;
  final Issue issue;

  ProjectTasksPage({Key? key, required this.parentIssue, required this.issue})
      : super(key: key);

  @override
  _ProjectTasksPageState createState() => _ProjectTasksPageState();
}

class _ProjectTasksPageState extends State<ProjectTasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Tasks'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: IssueDetailsBody(issue: widget.issue), // Use widget.issue
          ),
          Expanded(
            flex: 3,
            child: IssueChildBody(parentIssue: widget.parentIssue), // Use widget.parentIssue
          ),
        ],
      ),
    );
  }
}
