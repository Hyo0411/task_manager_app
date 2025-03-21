import 'package:flutter/material.dart';
import 'package:task_manager_app/core/models/tasks_model.dart';
import 'package:task_manager_app/database/database_helper.dart';

class TaskListViewModel extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;
  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;

  void setIsCompleted(bool value) {
    _isCompleted = value;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _tasks = await _databaseHelper.getTasks(); // Lấy tất cả công việc từ DB
    notifyListeners(); // Thông báo UI cập nhật
  }

  Future<void> addTask(TaskModel task) async {
    await _databaseHelper.insertTask(task); // Thêm công việc vào DB
    loadTasks(); // Làm mới danh sách công việc
  }

  // Cập nhật công việc
  Future<void> updateTask(TaskModel updatedTask) async {
    await _databaseHelper.updateTask(
      updatedTask,
    ); // Cập nhật công việc trong DB
    loadTasks(); // Làm mới danh sách công việc
  }

  // Xóa công việc
  Future<bool> removeTask(int? id) async {
    if (id != null) {
      await _databaseHelper.deleteTask(id); // Xóa công việc trong DB
      loadTasks(); // Làm mới danh sách công việc
      return true;
    }
    return false;
  }
}
