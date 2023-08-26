import 'package:flutter/material.dart';
import '../model/issue.dart';

class IssueList extends StatelessWidget {
  const IssueList({
    Key? key,
    required this.currentIssues,
    required this.toggleIssueCompletion,
    required this.removeIssue,
    required this.viewIssueDetails,
    this.onIssueLongPress,
  }) : super(key: key);

  final List<Issue> currentIssues;
  final Function toggleIssueCompletion;
  final Function removeIssue;
  final Function(Issue) viewIssueDetails;
  final Function(Issue)? onIssueLongPress;

  @override
  Widget build(BuildContext context) {
    final reversedIssues = currentIssues.reversed.toList();

    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: reversedIssues.length,
        itemBuilder: (context, index) {
          final issue = reversedIssues[index];
          return Dismissible(
            key: Key(issue.title),
            direction: DismissDirection.startToEnd,
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
              removeIssue(currentIssues, currentIssues.length - 1 - index);
            },
            child: InkWell(
              onTap: () => viewIssueDetails(issue),
              onLongPress: () {
                onIssueLongPress!(issue);
                _showMovedToTodaySnackBar(context, issue);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  tileColor: issue.isCompleted ? Colors.grey[200] : null,
                  leading: Checkbox(
                    value: issue.isCompleted,
                    onChanged: (value) => toggleIssueCompletion(
                        currentIssues, currentIssues.length - 1 - index),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        issue.title,
                        style: TextStyle(
                          decoration: issue.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      issue.storyPoint != null
          ? Text('${issue.storyPoint}')
          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMovedToTodaySnackBar(BuildContext context, Issue issue) {
    final snackBar = SnackBar(
      content: Text('Issue Moved to Today: ${issue.title}'),
      duration: const Duration(milliseconds: 300),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
