import 'package:flutter/material.dart';
import '../models/task_model.dart';

// TODO: Build the visual representation of a single task using Material Design components.
// It must display the title, truncated description, due date, priority badge, and status.
class TaskCardWidget extends StatelessWidget {
  final TaskModel task;

  const TaskCardWidget({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}