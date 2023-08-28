import 'package:flutter/material.dart';
import '../model/issue.dart';
import '../ui/issue_details_body.dart';

class IssueDetailsPage extends StatelessWidget {
  final Issue issue;

  IssueDetailsPage({Key? key, required this.issue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Details'),
      ),
      body: IssueDetailsBody(issue: issue),
    );
  }
}
