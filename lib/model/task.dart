class Task {
  String title;
  bool isCompleted;
  String section;

  Task({required this.title, this.isCompleted = false, this.section = ''});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'section':section
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isCompleted: json['isCompleted'],
      section:json['section']
    );
  }
}



