// lib/services/task_service.dart

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/task_model.dart';

class TaskService {
  static const String _className = 'Task';

  // ── Helpers ──────────────────────────────────────────────────

  ParseObject _toParseObject(TaskModel task) {
    final obj = ParseObject(_className);
    if (task.objectId != null) obj.objectId = task.objectId;
    obj.set('title', task.title);
    obj.set('description', task.description);
    obj.set('isCompleted', task.isCompleted);
    return obj;
  }

  TaskModel _fromParseObject(ParseObject obj) {
    return TaskModel(
      objectId: obj.objectId,
      title: obj.get<String>('title') ?? '',
      description: obj.get<String>('description') ?? '',
      isCompleted: obj.get<bool>('isCompleted') ?? false,
      createdAt: obj.createdAt,
      updatedAt: obj.updatedAt,
    );
  }

  // ── CREATE ────────────────────────────────────────────────────

  Future<Map<String, dynamic>> createTask({
    required String title,
    required String description,
  }) async {
    try {
      final currentUser = await ParseUser.currentUser() as ParseUser?;
      if (currentUser == null) {
        return {'success': false, 'message': 'Not logged in'};
      }

      final obj = ParseObject(_className)
        ..set('title', title)
        ..set('description', description)
        ..set('isCompleted', false)
        // Restrict task visibility to the owner only
        ..setACL(ParseACL(owner: currentUser));

      final response = await obj.save();

      if (response.success && response.result != null) {
        return {
          'success': true,
          'task': _fromParseObject(response.result as ParseObject),
        };
      }
      return {
        'success': false,
        'message': response.error?.message ?? 'Failed to create task',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ── READ (all tasks for current user) ─────────────────────────

  Future<Map<String, dynamic>> getTasks() async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject(_className))
        ..orderByDescending('createdAt');

      final response = await query.query();

      if (response.success) {
        final tasks = (response.results ?? [])
            .map((e) => _fromParseObject(e as ParseObject))
            .toList();
        return {'success': true, 'tasks': tasks};
      }
      return {
        'success': false,
        'message': response.error?.message ?? 'Failed to fetch tasks',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ── UPDATE ────────────────────────────────────────────────────

  Future<Map<String, dynamic>> updateTask(TaskModel task) async {
    try {
      if (task.objectId == null) {
        return {'success': false, 'message': 'Task has no ID'};
      }

      final obj = _toParseObject(task);
      final response = await obj.save();

      if (response.success) {
        return {'success': true};
      }
      return {
        'success': false,
        'message': response.error?.message ?? 'Failed to update task',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Toggle the completion status of a task.
  Future<Map<String, dynamic>> toggleTaskCompletion(TaskModel task) async {
    return updateTask(task.copyWith(isCompleted: !task.isCompleted));
  }

  // ── DELETE ────────────────────────────────────────────────────

  Future<Map<String, dynamic>> deleteTask(String objectId) async {
    try {
      final obj = ParseObject(_className)..objectId = objectId;
      final response = await obj.delete();

      if (response.success) {
        return {'success': true};
      }
      return {
        'success': false,
        'message': response.error?.message ?? 'Failed to delete task',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
