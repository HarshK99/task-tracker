class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }
}

class TaskSection {
  final String sectionName;
  final List<Task> tasks;

  TaskSection({required this.sectionName, required this.tasks});
}

