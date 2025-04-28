
class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;

  Task ({
    this.id = '',
    required this.title,
    this.description = '',
    this.isCompleted = false,
    DateTime? createdAt
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
    };
  }

  static Task fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
    );
  }
}