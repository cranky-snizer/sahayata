class DailyRoutine {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> daysOfWeek; // ['Monday', 'Tuesday', etc.]
  final bool isRecurring;
  final String category; // 'Work', 'Personal', 'Health', etc.
  final int priority; // 1-5
  final bool isCompleted;

  DailyRoutine({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.daysOfWeek,
    this.isRecurring = true,
    required this.category,
    this.priority = 3,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'daysOfWeek': daysOfWeek,
      'isRecurring': isRecurring,
      'category': category,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  factory DailyRoutine.fromMap(Map<String, dynamic> map) {
    return DailyRoutine(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      daysOfWeek: List<String>.from(map['daysOfWeek']),
      isRecurring: map['isRecurring'],
      category: map['category'],
      priority: map['priority'],
      isCompleted: map['isCompleted'],
    );
  }

  DailyRoutine copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? daysOfWeek,
    bool? isRecurring,
    String? category,
    int? priority,
    bool? isCompleted,
  }) {
    return DailyRoutine(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isRecurring: isRecurring ?? this.isRecurring,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TimeSlot {
  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final List<DailyRoutine> routines;

  TimeSlot({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    this.routines = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'routines': routines.map((routine) => routine.toMap()).toList(),
    };
  }

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      id: map['id'],
      name: map['name'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      routines: (map['routines'] as List)
          .map((routine) => DailyRoutine.fromMap(routine))
          .toList(),
    );
  }

  TimeSlot copyWith({
    String? id,
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    List<DailyRoutine>? routines,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      routines: routines ?? this.routines,
    );
  }
} 