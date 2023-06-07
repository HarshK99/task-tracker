class Task {
  int id;
  String title;
  bool isCompleted;
  DateTime dateTime;
  String description;
  String parentSection;
  String section;

  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.dateTime,
    required this.description,
    required this.parentSection,
    required this.section,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
      'parentSection': parentSection,
      'section': section,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
      isCompleted: map['isCompleted'] == 1,
      dateTime: DateTime.parse(map['dateTime'] as String),
      description: map['description'] as String,
      parentSection: map['parentSection'] as String,
      section: map['section'] as String,
    );
  }
}
