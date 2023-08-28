import 'package:flutter/material.dart';
import 'package:task_tracker/ui/issue_child_body.dart';
import '../model/issue.dart';

class IssueChildPage extends StatefulWidget {
  final Issue parentIssue;

  IssueChildPage({super.key, required this.parentIssue});

  @override
  _IssueChildPageState createState() => _IssueChildPageState();
}

class _IssueChildPageState extends State<IssueChildPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Issues'),
      ),
      body: IssueChildBody(parentIssue: widget.parentIssue)
    );
  }
}
