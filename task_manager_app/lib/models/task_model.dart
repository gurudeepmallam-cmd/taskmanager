// lib/models/task_model.dart

class TaskModel {
  final String? objectId;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskModel({
    this.objectId,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  TaskModel copyWith({
    String? objectId,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      objectId: objectId ?? this.objectId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
