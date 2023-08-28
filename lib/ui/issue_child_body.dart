import 'package:flutter/material.dart';
import '../model/issue.dart';
import '../db/issue_database.dart';
import '../pages/issue_details_page.dart';
import '../ui/issue_list.dart';
import '../ui/issue_input_field.dart';

class IssueChildBody extends StatefulWidget {
  final Issue parentIssue;

  IssueChildBody({super.key, required this.parentIssue});

  @override
  _IssueChildBodyState createState() => _IssueChildBodyState();
}

class _IssueChildBodyState extends State<IssueChildBody> {
  List<Issue> _childIssues = [];
  final TextEditingController _textEditingController = TextEditingController();
  int? _selectedStoryPoint;
  String? _selectedPriority;


  @override
  void initState() {
    super.initState();
    loadChildIssues();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadChildIssues();
  }


  Future<void> loadChildIssues() async {
    final parentIssue = widget.parentIssue;
    final childIssues = await IssueDatabase.instance.loadChildIssues(parentIssue.id);
    print("LoadChildIssues");

    setState(() {
      _childIssues = childIssues;
    });
  }



  Future<void> _addChildIssue() async {
    final newIssue = _textEditingController.text;
    if (newIssue.isNotEmpty) {
      final storyPoint = _selectedStoryPoint;
      final priority = _selectedPriority;

      final childIssue = Issue(
        id: DateTime.now().microsecondsSinceEpoch,
        title: newIssue,
        isCompleted: false,
        dateTime: DateTime.now(),
        description: '',
        projectId: widget.parentIssue.id,
        storyPoint: storyPoint,
        priority: priority,
      );

      await IssueDatabase.instance.insertIssue(childIssue);

      setState(() {
        _childIssues.add(childIssue);
        _textEditingController.clear();
        _selectedStoryPoint = null;
        _selectedPriority = null;
      });
    }
  }

  Future<void> _removeChildIssue(List<Issue> issueList,int index) async {
    final childIssue = issueList[index];
    await IssueDatabase.instance.deleteIssue(childIssue);

    setState(() {
      _childIssues.removeAt(index);
    });
  }

  Future<void> _toggleChildIssueCompletion(List<Issue> issueList,int index) async {
    final childIssue = issueList[index];
    final updatedChildIssue = childIssue.copyWith(isCompleted: !childIssue.isCompleted);

    await IssueDatabase.instance.updateIssue(updatedChildIssue);

    setState(() {
      _childIssues[index] = updatedChildIssue;
    });
  }

  void _handleIssueLongPress(Issue issue) async{
    final parentIssue = widget.parentIssue;

    // Update the parentSection to 'Today'
    final updatedIssue = issue.copyWith(section: parentIssue.section);
    print('Long pressed issue: ${updatedIssue.title},${updatedIssue.section}');
    await IssueDatabase.instance.updateIssue(updatedIssue);


    setState(() {
    });
  }

  Future<void> _navigateToIssueDetails(BuildContext context, Issue issue) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => IssueDetailsPage(issue: issue)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          IssueList(
            currentIssues: _childIssues,
            toggleIssueCompletion: _toggleChildIssueCompletion,
            removeIssue: _removeChildIssue,
            viewIssueDetails: (issue) => _navigateToIssueDetails(context, issue),
            onIssueLongPress: _handleIssueLongPress,
          ),
          IssueInputField(
            textEditingController: _textEditingController,
            addIssue: _addChildIssue,
            onStoryPointChanged: (selectedPoint) =>               _selectedStoryPoint = selectedPoint,
          onPriorityChanged: (selectedPriority) =>              _selectedPriority = selectedPriority)
        ]
    );
}}