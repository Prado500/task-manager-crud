import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import '../widgets/task_card_widget.dart';

/// Main wrapper layout acting as the host for the bottom navigation
/// and the primary task list view.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  String _selectedStatus = 'All';
  String _selectedPriority = 'All';

  // Backend value mappings for Status filters
  final Map<String, String> _statusOptions = {
    'All': 'All',
    'pending': 'Pending',
    'in_progress': 'In Progress',
    'completed': 'Done',
  };

  // Backend value mappings for Priority filters
  final Map<String, String> _priorityOptions = {
    'All': 'All',
    'high': 'High',
    'medium': 'Medium',
    'low': 'Low',
  };

  @override
  Widget build(BuildContext context) {

    final viewModel = context.watch<TaskViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'TaskFlow',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
            onPressed: () {}, // Future settings implementation
          ),
        ],
      ),
      body: _currentIndex == 0 ? _buildTaskList(viewModel) : _buildInsightsPlaceholder(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // TODO: Navigate to CreateTaskView
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Insights',
          ),
        ],
      ),
    );
  }

  /// Assembles the task list tab including dynamic filters and the scrollable card list.
  Widget _buildTaskList(TaskViewModel viewModel) {
    return Column(
      children: [
        _buildFilters(viewModel),
        const SizedBox(height: 8),
        Expanded(
          child: _buildListContent(viewModel),
        ),
      ],
    );
  }

  /// Renders scrollable filter chips and triggers state updates on selection.
  Widget _buildFilters(TaskViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _statusOptions.entries.map((entry) {
                final isSelected = _selectedStatus == entry.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    selectedColor: Colors.black,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedStatus = entry.key);
                        viewModel.fetchTasks(status: _selectedStatus, priority: _selectedPriority);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // Priority Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _priorityOptions.entries.map((entry) {
                final isSelected = _selectedPriority == entry.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    backgroundColor: Colors.white,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedPriority = entry.key);
                        viewModel.fetchTasks(status: _selectedStatus, priority: _selectedPriority);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Resolves the UI state (Loading, Error, Empty, or Populated List).
  Widget _buildListContent(TaskViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Text(
          viewModel.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (viewModel.tasks.isEmpty) {
      return const Center(
        child: Text(
          "No tasks match your filters. Add a new one!",
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.tasks.length,
      itemBuilder: (context, index) {
        final task = viewModel.tasks[index];
        return TaskCardWidget(
          task: task,
          onEdit: () {
            // TODO: Navigate to Edit View passing the task
          },
          onDelete: () async {
            final success = await viewModel.deleteTask(task.taskId!);
            if (success && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        );
      },
    );
  }

  /// Temporary placeholder for the upcoming Insights tab.
  Widget _buildInsightsPlaceholder() {
    return const Center(
      child: Text(
        "Insights View coming next...",
        style: TextStyle(color: Colors.black54, fontSize: 16),
      ),
    );
  }
}