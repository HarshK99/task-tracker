import 'package:flutter/material.dart';
import 'issue_page_body.dart';

class IssuePage extends StatelessWidget {
  const IssuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Page'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.fiber_new), text: 'Projects'),
              Tab(icon: Icon(Icons.today), text: "Today's Tasks"),
              Tab(icon: Icon(Icons.calendar_today), text: 'Daily Tasks'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            IssuePageBody(currentParentIndex: 0, getParentSection: 'projects'),
            IssuePageBody(currentParentIndex: 1,getParentSection: 'todayTasks'),
            IssuePageBody(currentParentIndex: 2,getParentSection: 'dailyTasks'),
          ],
        ),
      ),
    );
  }
}
