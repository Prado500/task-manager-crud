// TODO: Implement fromJson and toJson factory methods to map these properties


class TaskModel {
  final String taskId;
  final String title;
  String? description;
  final String dueDate;
  final String priority; // Accepted values: 'high', 'medium', 'low'
  final String status; // Accepted values: 'pending', 'in_progress', 'completed'
  final String originFramework; // Default: 'flutter'
  final String userEmail;

  TaskModel({
    required this.taskId,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.originFramework,
    required this.userEmail,
  });
}