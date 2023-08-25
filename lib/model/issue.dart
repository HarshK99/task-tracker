class Issue {
  int id;
  String title;
  String description;
  bool isCompleted;
  String? issueType;
  String? section;
  int? projectId;
  int? storyPoint;
  DateTime dateTime;

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    this.issueType,
    this.section,
    this.projectId,
    this.storyPoint,
    required this.dateTime,
  });

  Issue copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? issueType,
    String? section,
    int? projectId,
    int? storyPoint,
    DateTime? dateTime,
  }) {
    return Issue(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      issueType: issueType ?? this.issueType,
      section: section ?? this.section,
      projectId: projectId ?? this.projectId,
      storyPoint: storyPoint ?? this.storyPoint,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'issueType': issueType,
      'section': section,
      'projectId': projectId,
      'storyPoint': storyPoint,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Issue.fromMap(Map<String, dynamic> map) {
    return Issue(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] == 1,
      issueType: map['issueType'] as String?,
      section: map['section'] as String?,
      projectId: map['projectId'] as int?,
      storyPoint: map['storyPoint'] as int?,
      dateTime: DateTime.parse(map['dateTime'] as String),
    );
  }
}
