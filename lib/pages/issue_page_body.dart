import 'package:flutter/material.dart';
import '../model/issue.dart';
import '../ui/issue_list.dart';
import '../ui/issue_input_field.dart';
import '../ui/section_row.dart';
import '../db/issue_database.dart';
import 'issue_child_page.dart';

typedef ShowSnackBarCallback = void Function(String message);

class IssuePageBody extends StatefulWidget {
  const IssuePageBody(
      {Key? key,
      required this.currentParentIndex,
      required this.currentIssueType})
      : super(key: key);

  final int currentParentIndex;
  final int currentIssueType;

  @override
  State<IssuePageBody> createState() => _IssuePageBodyState();
}

class _IssuePageBodyState extends State<IssuePageBody> {
  List<Issue> _issues = [];
  List<String> _sections = [];
  int _currentSectionIndex = 0;
  late final ShowSnackBarCallback showSnackBar;

  final TextEditingController _textEditingController = TextEditingController();
  int? _selectedStoryPoint;
  String? _selectedPriority;


  @override
  void initState() {
    super.initState();
    loadSections();
      loadIssueData();
    }
  // }

  // @override
  // void didUpdateWidget(IssuePageBody oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.getParentSection != widget.getParentSection) {
  //     _currentSectionIndex = 0;
  //     // loadSections().then((_) {
  //       loadIssueData();
  //     // });
  //   }
  // }

  Future<void> loadSections() async {
    final sections = await IssueDatabase.instance.loadSections();

    // "All" subsection, add it at the first position
    sections.insert(0, 'All');

    setState(() {
      _sections = sections;
    });
  }

  Future<void> loadIssueData() async {
    final issueType = widget.currentIssueType;
    final section = _sections.isNotEmpty
        ? _sections[_currentSectionIndex]
        : ''; // Get the section
    // Load issues based on the current subsection
    if (section == 'All') {
      final issues = await IssueDatabase.instance.loadAllIssues(issueType);
    setState(() {
      _issues = issues;
    });
    } else {
      final issues =
      await IssueDatabase.instance.loadIssuesBySections(issueType, section);
      setState(() {
        _issues = issues;
      });
  }}



Future<void> _addIssue(List<Issue> issueList) async {
  final issueType = widget.currentIssueType;
  final newIssue = _textEditingController.text;
  
  if (newIssue.isNotEmpty) {
    final storyPoint = _selectedStoryPoint;
    final priority = _selectedPriority; 
    
    final issue = Issue(
      id: DateTime.now().microsecondsSinceEpoch,
      title: newIssue,
      issueType: issueType,
      isCompleted: false,
      dateTime: DateTime.now(),
      description: '',
      section: _sections[_currentSectionIndex],
      storyPoint: storyPoint,
      priority: priority,
    );

    await IssueDatabase.instance.insertIssue(issue);

    setState(() {
      issueList.add(issue);
      _textEditingController.clear();
      _selectedStoryPoint = null;
      _selectedPriority = null;
    });
  }
}


  Future<void> _removeIssue(List<Issue> issueList, int index) async {
    final issue = issueList[index];
    final hasChildIssues = await IssueDatabase.instance.hasChildIssues(issue.id);

    if (hasChildIssues) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot remove issue with child issues'),
          ),
        );
      }
    } else {
        await IssueDatabase.instance.deleteIssue(issue);
      }

      setState(() {
        issueList.removeAt(index);
      });
  }

  Future<void> _toggleIssueCompletion(List<Issue> issueList, int index) async {
    final issue = issueList[index];
    final updatedIssue = Issue(
      id: issue.id,
      title: issue.title,
      issueType: issue.issueType,
      isCompleted: !issue.isCompleted,
      dateTime: issue.dateTime,
      description: issue.description,
      section: issue.section,
    );

    await IssueDatabase.instance.updateIssue(updatedIssue);

    setState(() {
      issueList[index] = updatedIssue;
    });
  }

  void _addSection(String sectionName) {
    if (sectionName.isNotEmpty) {
      IssueDatabase.instance.insertSection(sectionName).then((_) {
        setState(() {
          _sections.add(sectionName);
        });
      });
    }
  }

  void _switchSection(int index) {
    setState(() {
      _currentSectionIndex = index;
        loadIssueData();
    });
  }


  Future<void> _navigateToIssueChild(BuildContext context, Issue issue) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return IssueChildPage(parentIssue: issue);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration:
            Duration(milliseconds: 300), // Adjust the duration as needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Issue> currentIssues = _issues;

    return Column(
      children: <Widget>[
        SectionRow(
          sections: _sections,
          currentSectionIndex: _currentSectionIndex,
          addSection: _addSection,
          switchSection: _switchSection,
        ),
        IssueList(
            currentIssues: currentIssues,
            toggleIssueCompletion: _toggleIssueCompletion,
            removeIssue: _removeIssue,
            viewIssueDetails: (issue) => _navigateToIssueChild(context, issue)),
        IssueInputField(
          textEditingController: _textEditingController,
          addIssue: () => _addIssue(currentIssues),
        ),
      ],
    );
  }
}
