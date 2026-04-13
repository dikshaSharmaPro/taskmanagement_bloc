import 'package:supabase_flutter/supabase_flutter.dart';

class AppLogicException implements Exception {
  final String message;
  AppLogicException(this.message);

  @override
  String toString() => 'AppLogicException: $message';
}

Future<void> deleteTaskFromSupabase(String id) async {
  final supabase = Supabase.instance.client;

  try {
    await supabase.from('tasks').delete().eq('id', id);
  } catch (e) {
    throw AppLogicException('An error occurred while deleting the task: $e');
  }
}

Future<void> updateTaskInSupabase({
  required String id,
  required String title,
  required String description,
  required String datetime,
  required bool isCompleted,
}) async {
  final supabase = Supabase.instance.client;

  try {
    await supabase
        .from('tasks')
        .update({
          'title': title,
          'description': description,
          'datetime': datetime,
          'isCompleted': isCompleted,
        })
        .eq('id', id);
  } catch (e) {
    throw AppLogicException('An error occurred while updating the task: $e');
  }
}

Future<void> addTaskToSupabase(
  String id,
  String title,
  String description,
  String datetime,
  bool isCompleted,
  String userId,
) async {
  final supabase = Supabase.instance.client;

  try {
    await supabase.from('tasks').insert({
      'id': id,
      'title': title,
      'description': description,
      'datetime': datetime,
      'isCompleted': isCompleted,
      'user_id': userId,
    });
  } catch (e) {
    throw AppLogicException('An error occurred while adding the task: $e');
  }
}
