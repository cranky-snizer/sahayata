import 'package:flutter/foundation.dart';
import '../models/daily_routine.dart';
import '../models/time_slot.dart';
import '../helpers/database_helper.dart';

class RoutineProvider with ChangeNotifier {
  List<DailyRoutine> _routines = [];
  List<TimeSlot> _timeSlots = [];
  bool _isLoading = false;

  List<DailyRoutine> get routines => _routines;
  List<TimeSlot> get timeSlots => _timeSlots;
  bool get isLoading => _isLoading;

  // Initialize default time slots
  void initializeTimeSlots() {
    _timeSlots = [
      TimeSlot(
        id: '1',
        name: 'Morning',
        startTime: DateTime(2024, 1, 1, 6, 0),
        endTime: DateTime(2024, 1, 1, 12, 0),
      ),
      TimeSlot(
        id: '2',
        name: 'Afternoon',
        startTime: DateTime(2024, 1, 1, 12, 0),
        endTime: DateTime(2024, 1, 1, 17, 0),
      ),
      TimeSlot(
        id: '3',
        name: 'Evening',
        startTime: DateTime(2024, 1, 1, 17, 0),
        endTime: DateTime(2024, 1, 1, 22, 0),
      ),
      TimeSlot(
        id: '4',
        name: 'Night',
        startTime: DateTime(2024, 1, 1, 22, 0),
        endTime: DateTime(2024, 1, 2, 6, 0),
      ),
    ];
  }

  // Load routines from database
  Future<void> loadRoutines() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> maps = await db.query('routines');
      _routines = maps.map((map) => DailyRoutine.fromMap(map)).toList();
    } catch (e) {
      print('Error loading routines: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a new routine
  Future<void> addRoutine(DailyRoutine routine) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert('routines', routine.toMap());
      _routines.add(routine);
      notifyListeners();
    } catch (e) {
      print('Error adding routine: $e');
    }
  }

  // Update a routine
  Future<void> updateRoutine(DailyRoutine routine) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'routines',
        routine.toMap(),
        where: 'id = ?',
        whereArgs: [routine.id],
      );
      final index = _routines.indexWhere((r) => r.id == routine.id);
      if (index != -1) {
        _routines[index] = routine;
      }
      notifyListeners();
    } catch (e) {
      print('Error updating routine: $e');
    }
  }

  // Delete a routine
  Future<void> deleteRoutine(String id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete(
        'routines',
        where: 'id = ?',
        whereArgs: [id],
      );
      _routines.removeWhere((routine) => routine.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting routine: $e');
    }
  }

  // Get routines for a specific day
  List<DailyRoutine> getRoutinesForDay(DateTime date) {
    final dayOfWeek = _getDayOfWeek(date);
    return _routines.where((routine) {
      return routine.daysOfWeek.contains(dayOfWeek);
    }).toList();
  }

  // Get routines for a specific time slot
  List<DailyRoutine> getRoutinesForTimeSlot(TimeSlot timeSlot) {
    return _routines.where((routine) {
      final routineStart = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        routine.startTime.hour,
        routine.startTime.minute,
      );
      final routineEnd = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        routine.endTime.hour,
        routine.endTime.minute,
      );
      return routineStart.isAfter(timeSlot.startTime) &&
          routineEnd.isBefore(timeSlot.endTime);
    }).toList();
  }

  // Helper method to get day of week
  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  // Get completion percentage for a specific day
  double getCompletionPercentage(DateTime date) {
    final dayRoutines = getRoutinesForDay(date);
    if (dayRoutines.isEmpty) return 0.0;
    final completedRoutines =
        dayRoutines.where((routine) => routine.isCompleted).length;
    return completedRoutines / dayRoutines.length;
  }
} 