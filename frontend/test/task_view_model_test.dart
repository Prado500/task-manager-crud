import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_client/models/task_model.dart';
import 'package:task_manager_client/viewmodels/task_view_model.dart';
import 'package:task_manager_client/abstractions/supervisa_task_api_abstraction.dart';


/// Manual mock implementation of the API abstraction to isolate the ViewModel
/// from actual network requests during testing.
class MockSupervisaApiAbstraction implements SupervisaApiAbstraction {
  bool shouldFail = false;
  List<TaskModel> mockDatabase = [];

  @override
  Future<List<TaskModel>> getTasks({String? status, String? priority}) async {
    if (shouldFail) throw Exception("Network Error");
    return mockDatabase;
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    if (shouldFail) throw Exception("Network Error");
    mockDatabase.add(task);
    return task;
  }

  @override
  Future<TaskModel> updateTask(String taskId, Map<String, dynamic> updates) async {
    if (shouldFail) throw Exception("Network Error");
    return mockDatabase.first;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    if (shouldFail) throw Exception("Network Error");
    mockDatabase.removeWhere((t) => t.taskId == taskId);
  }
}

void main() {
  late TaskViewModel viewModel;
  late MockSupervisaApiAbstraction mockApi;

  // Runs before each test to ensure a clean state
  setUp(() {
    mockApi = MockSupervisaApiAbstraction();
    // Dependency Injection: Passing the mock API instead of the real one
    viewModel = TaskViewModel(api: mockApi);
  });

  group('TaskViewModel Tests -', () {
    test('fetchTasks successfully updates state with tasks from API', () async {
      // Arrange
      mockApi.mockDatabase = [
        TaskModel(taskId: '1', title: 'Test 1', dueDate: '2026-07-04', priority: 'high', status: 'pending'),
      ];

      // Act
      expect(viewModel.isLoading, false);
      await viewModel.fetchTasks();

      // Assert
      expect(viewModel.isLoading, false);
      expect(viewModel.tasks.length, 1);
      expect(viewModel.tasks.first.title, 'Test 1');
      expect(viewModel.errorMessage, isNull);
    });

    test('fetchTasks handles network exceptions gracefully', () async {
      // Arrange
      mockApi.shouldFail = true;

      // Act
      await viewModel.fetchTasks();

      // Assert
      expect(viewModel.isLoading, false);
      expect(viewModel.tasks.isEmpty, true);
      expect(viewModel.errorMessage, "Connection error with the local server.");
    });

    test('Insights getters calculate correct statistics based on internal list', () async {
      // Arrange
      mockApi.mockDatabase = [
        TaskModel(taskId: '1', title: 'T1', dueDate: '2026-07-04', priority: 'high', status: 'completed'),
        TaskModel(taskId: '2', title: 'T2', dueDate: '2026-07-04', priority: 'medium', status: 'pending'),
        TaskModel(taskId: '3', title: 'T3', dueDate: '2026-07-04', priority: 'low', status: 'in_progress'),
      ];

      // Act
      await viewModel.fetchTasks();

      // Assert
      expect(viewModel.totalTasks, 3);
      expect(viewModel.completedTasks, 1);
      expect(viewModel.highPriorityTasks, 1);
      expect(viewModel.mediumPriorityTasks, 1);
      expect(viewModel.lowPriorityTasks, 1);
    });
  });
}