import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/task_model.dart';

class SharedPreferencesHelper {
  static const String _taskListKey = 'task_list';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final taskJsonList =
        tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList(_taskListKey, taskJsonList);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskJsonList = prefs.getStringList(_taskListKey);
    if (taskJsonList != null) {
      return taskJsonList
          .map((taskJson) => Task.fromJson(json.decode(taskJson)))
          .toList();
    }
    return [];
  }
}
