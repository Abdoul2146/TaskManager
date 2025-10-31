/// The Task model represents a single task in the app.
/// It includes all fields needed for display, editing, and persistence.
class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? dueDate;
  final String priority;

  /// Constructor for creating a Task instance.
  Task({
    this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.dueDate,
    this.priority = 'Medium',
  });

  /// Creates a copy of this Task with optional new values.
  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    String? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }

  /// Factory constructor to create a Task from a Map (e.g., from the database).
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'],
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] == 1,
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'])
          : null,
      priority: map['priority'] ?? 'Medium',
    );
  }

  /// Converts this Task to a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
    };
  }
}
