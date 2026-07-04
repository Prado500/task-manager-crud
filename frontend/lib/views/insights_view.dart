import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';

/// Renders a dashboard displaying productivity statistics.
/// Consumes derived state from the TaskViewModel to populate progress indicators.
class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TaskViewModel>();

    final total = viewModel.totalTasks;
    final completed = viewModel.completedTasks;

    // Protect against division by zero
    final completionRate = total > 0 ? (completed / total) : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de Estadísticas',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aquí tienes un resumen de tu productividad.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 32),

          // Total Tasks Card
          _buildSummaryCard(
            title: 'TAREAS TOTALES',
            icon: Icons.assignment_turned_in,
            mainValue: '$total',
            subText: total > 0
                ? '${(completionRate * 100).toStringAsFixed(1)}% completadas'
                : 'Aún no hay tareas',
            progressValue: completionRate,
            progressColor: Colors.blue.shade700,
          ),
          const SizedBox(height: 24),

          // Priority Breakdown Card
          _buildPriorityBreakdownCard(viewModel),
        ],
      ),
    );
  }

  /// Builds a generic summary card with a progress bar.
  Widget _buildSummaryCard({
    required String title,
    required IconData icon,
    required String mainValue,
    required String subText,
    required double progressValue,
    required Color progressColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.black54),
              ),
              Icon(icon, color: Colors.blue.shade700, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                mainValue,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text('tareas', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Text(subText, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }

  /// Builds a detailed card showing the breakdown of tasks by priority.
  Widget _buildPriorityBreakdownCard(TaskViewModel viewModel) {
    final total = viewModel.totalTasks;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'DESGLOSE POR PRIORIDAD',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.black54),
              ),
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          _buildPriorityRow('Alta', viewModel.highPriorityTasks, total, Colors.red),
          const SizedBox(height: 16),
          _buildPriorityRow('Media', viewModel.mediumPriorityTasks, total, Colors.yellow.shade700),
          const SizedBox(height: 16),
          _buildPriorityRow('Baja', viewModel.lowPriorityTasks, total, Colors.green),
        ],
      ),
    );
  }

  /// Builds an individual row for the priority breakdown.
  Widget _buildPriorityRow(String label, int count, int total, Color color) {
    final fraction = total > 0 ? count / total : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: fraction,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 20,
          child: Text('$count', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
      ],
    );
  }
}