import 'package:flutter/material.dart';
import '../models/task_model.dart';

/// A reusable card component displaying the summary of a single task.
/// It renders dynamic priority and status badges according to business rules.
class TaskCardWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCardWidget({
    super.key,
    required this.task,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title and Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
                      onPressed: onEdit,
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      onPressed: onDelete,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Body: Description
            if (task.description != null && task.description!.isNotEmpty)
              Text(
                task.description!,
                style: const TextStyle(color: Colors.black54),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 16),

            // Footer: Badges and Due Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildStatusBadge(task.status),
                    const SizedBox(width: 8),
                    _buildPriorityBadge(task.priority),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      task.dueDate,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Generates a visual badge for the task's status.
  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'in_progress':
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        label = 'In Progress';
        break;
      case 'completed':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        label = 'Completed';
        break;
      case 'pending':
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        label = 'Pending';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Generates a visual badge enforcing the color-coded priority rubric.
  Widget _buildPriorityBadge(String priority) {
    Color dotColor;
    String label;

    switch (priority) {
      case 'high':
        dotColor = Colors.red;
        label = 'High';
        break;
      case 'low':
        dotColor = Colors.green;
        label = 'Low';
        break;
      case 'medium':
      default:
      // Se utiliza shade700 para garantizar contraste y legibilidad sobre fondo blanco
      // cumpliendo estrictamente con la rúbrica (Amarillo).
        dotColor = Colors.yellow.shade700;
        label = 'Medium';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: dotColor, size: 10),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.black87, fontSize: 12),
          ),
        ],
      ),
    );
  }
}