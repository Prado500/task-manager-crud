import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../abstractions/supervisa_task_api_abstraction.dart';

/// Orchestrates state management for task-related operations.
/// Acts as the single source of truth between the UI and the network abstraction layer.
class TaskViewModel extends ChangeNotifier {
  final SupervisaApiAbstraction _api;

  /// Injects the API abstraction dependency to decouple networking and facilitate testing.
  TaskViewModel({SupervisaApiAbstraction? api})
      : _api = api ?? SupervisaApiAbstraction();

  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.status == 'completed').length;
  int get highPriorityTasks => _tasks.where((t) => t.priority == 'high').length;
  int get mediumPriorityTasks => _tasks.where((t) => t.priority == 'medium').length;
  int get lowPriorityTasks => _tasks.where((t) => t.priority == 'low').length;

  /// Fetches the list of tasks from the backend, optionally applying filters.
  Future<void> fetchTasks({String? status, String? priority}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _api.getTasks(status: status, priority: priority);
    } catch (e) {
      _errorMessage = "Connection error with the local server.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Persists a new task to the backend and refreshes the local state.
  Future<bool> createTask(TaskModel newTask) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _api.createTask(newTask);
      await fetchTasks();
      return true;
    } catch (e) {
      _errorMessage = "Failed to create the task.";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Applies partial updates to an existing task and refreshes the local state.
  Future<bool> updateTask(String taskId, Map<String, dynamic> updates) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _api.updateTask(taskId, updates);
      await fetchTasks();
      return true;
    } catch (e) {
      _errorMessage = "Failed to update the task.";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Permanently deletes a task from the backend and updates the local cache.
  Future<bool> deleteTask(String taskId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _api.deleteTask(taskId);
      _tasks.removeWhere((t) => t.taskId == taskId);
      return true;
    } catch (e) {
      _errorMessage = "Failed to delete the task.";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}