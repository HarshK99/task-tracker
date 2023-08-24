import 'package:flutter/material.dart';
import 'task_page_body.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

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
              Tab(icon: Icon(Icons.fiber_new), text: 'New Tasks'),
              Tab(icon: Icon(Icons.today), text: "Today's Tasks"),
              Tab(icon: Icon(Icons.calendar_today), text: 'Daily Tasks'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TaskPageBody(currentParentIndex: 0, getParentSection: 'newTasks'),
            TaskPageBody(currentParentIndex: 1,getParentSection: 'todayTasks'),
            TaskPageBody(currentParentIndex: 2,getParentSection: 'dailyTasks'),
          ],
        ),
      ),
    );
  }
}
