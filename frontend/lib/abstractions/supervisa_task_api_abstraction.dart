import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/task_model.dart';
import '../models/pokemon_model.dart';

class SupervisaApiAbstraction {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000/api/v1',
    ),
  );

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

  // ... tus métodos anteriores ...

  // NUEVO MÉTODO PARA POKEMON
  Future<List<PokemonModel>> getTopPokemon() async {
    try {
      final response = await _dio.get('/pokemon/');
      return (response.data as List)
          .map((json) => PokemonModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener Pokémon: $e');
    }
  }

}