class TaskModel {
  final String? taskId;
  final String title;
  final String? description;
  final String dueDate;
  final String priority;
  final String status;
  final String originFramework;
  final String userEmail;

  TaskModel({
    this.taskId,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.originFramework = 'flutter',
    this.userEmail = 'aspirante@supervisa.co',
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['task_id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['due_date'],
      priority: json['priority'],
      status: json['status'],
      originFramework: json['origin_framework'] ?? 'flutter',
      userEmail: json['user_email'] ?? 'aspirante@supervisa.co',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (taskId != null) 'task_id': taskId,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'priority': priority,
      'status': status,
      'origin_framework': originFramework,
      'user_email': userEmail,
    };
  }
}