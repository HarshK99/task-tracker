class Project {
  int id;
  String title;
  
  Project({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as int,
      title: map['title'] as String,
    );
  }
}
