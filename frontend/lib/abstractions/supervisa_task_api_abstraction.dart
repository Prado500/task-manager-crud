import 'package:dio/dio.dart';
import '../models/task_model.dart';

class SupervisaApiAbstraction {
  // Ajusta la IP si pruebas en un dispositivo físico
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/v1'));

  Future<List<TaskModel>> getTasks({String? status, String? priority}) async {
    try {
      final response = await _dio.get('/tasks/', queryParameters: {
        if (status != null && status != 'All') 'status': status,
        if (priority != null && priority != 'All') 'priority': priority,
      });
      return (response.data as List)
          .map((json) => TaskModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener tareas: $e');
    }
  }

  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await _dio.post('/tasks/', data: task.toJson());
      return TaskModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear tarea: $e');
    }
  }

  Future<TaskModel> updateTask(String taskId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put('/tasks/$taskId', data: updates);
      return TaskModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al actualizar tarea: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _dio.delete('/tasks/$taskId');
    } catch (e) {
      throw Exception('Error al eliminar tarea: $e');
    }
  }
}