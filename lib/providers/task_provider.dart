import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tasksList = await DatabaseHelper.instance.getAllTasks();
      _tasks = tasksList.map((map) => Task.fromMap(map)).toList();
    } catch (e) {
      _error = 'Failed to load tasks: $e';
      _tasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTasksByDate(DateTime date) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dateString = date.toIso8601String().split('T')[0];
      final tasksList = await DatabaseHelper.instance.getTasksByDate(dateString);
      _tasks = tasksList.map((map) => Task.fromMap(map)).toList();
      _selectedDate = date;
    } catch (e) {
      _error = 'Failed to load tasks for date: $e';
      _tasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    try {
      final id = await DatabaseHelper.instance.insertTask(task.toMap());
      _tasks.add(task.copyWith(id: id));
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add task: $e';
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await DatabaseHelper.instance.updateTask(task.toMap());
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update task: $e';
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await DatabaseHelper.instance.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete task: $e';
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await updateTask(updatedTask);
    } catch (e) {
      _error = 'Failed to toggle task completion: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 