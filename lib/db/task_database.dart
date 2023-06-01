import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/task.dart';

class TaskDatabase {
  static Future<void> saveTaskListToPrefs(List<Task> taskList, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = taskList.map((task) => task.toJson()).toList();
    await prefs.setString(key, jsonEncode(taskListJson));
  }

  static Future<List<Task>> loadTaskListFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = prefs.getString(key);
    if (taskListJson != null) {
      final taskListData = jsonDecode(taskListJson) as List<dynamic>;
      return taskListData.map((taskData) => Task.fromJson(taskData)).toList();
    } else {
      return [];
    }
  }
}
