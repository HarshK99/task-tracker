class IssueType {
  int id;
  String name;

  IssueType({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory IssueType.fromMap(Map<String, dynamic> map) {
    return IssueType(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
