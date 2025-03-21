class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final Map<String, dynamic> preferences;
  final List<String> categories;
  final Map<String, Color> categoryColors;
  final String themeMode; // 'light', 'dark', 'system'
  final bool notificationsEnabled;
  final Map<String, bool> notificationPreferences;
  final String timeZone;
  final String dateFormat;
  final String timeFormat;
  final int defaultReminderTime; // minutes before event
  final List<String> workingDays;
  final Map<String, TimeOfDay> workingHours;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.preferences = const {},
    this.categories = const [],
    this.categoryColors = const {},
    this.themeMode = 'system',
    this.notificationsEnabled = true,
    this.notificationPreferences = const {},
    this.timeZone = 'UTC',
    this.dateFormat = 'MMM dd, yyyy',
    this.timeFormat = '12h',
    this.defaultReminderTime = 30,
    this.workingDays = const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
    this.workingHours = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'preferences': preferences,
      'categories': categories,
      'categoryColors': categoryColors.map((key, value) => MapEntry(key, value.value)),
      'themeMode': themeMode,
      'notificationsEnabled': notificationsEnabled,
      'notificationPreferences': notificationPreferences,
      'timeZone': timeZone,
      'dateFormat': dateFormat,
      'timeFormat': timeFormat,
      'defaultReminderTime': defaultReminderTime,
      'workingDays': workingDays,
      'workingHours': workingHours.map((key, value) => 
        MapEntry(key, '${value.hour}:${value.minute}')),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      categories: List<String>.from(map['categories'] ?? []),
      categoryColors: (map['categoryColors'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, Color(value as int)),
      ) ?? {},
      themeMode: map['themeMode'] ?? 'system',
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      notificationPreferences: Map<String, bool>.from(map['notificationPreferences'] ?? {}),
      timeZone: map['timeZone'] ?? 'UTC',
      dateFormat: map['dateFormat'] ?? 'MMM dd, yyyy',
      timeFormat: map['timeFormat'] ?? '12h',
      defaultReminderTime: map['defaultReminderTime'] ?? 30,
      workingDays: List<String>.from(map['workingDays'] ?? ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']),
      workingHours: (map['workingHours'] as Map<String, dynamic>?)?.map(
        (key, value) {
          final parts = (value as String).split(':');
          return MapEntry(key, TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          ));
        },
      ) ?? {},
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    Map<String, dynamic>? preferences,
    List<String>? categories,
    Map<String, Color>? categoryColors,
    String? themeMode,
    bool? notificationsEnabled,
    Map<String, bool>? notificationPreferences,
    String? timeZone,
    String? dateFormat,
    String? timeFormat,
    int? defaultReminderTime,
    List<String>? workingDays,
    Map<String, TimeOfDay>? workingHours,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      preferences: preferences ?? this.preferences,
      categories: categories ?? this.categories,
      categoryColors: categoryColors ?? this.categoryColors,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      timeZone: timeZone ?? this.timeZone,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      defaultReminderTime: defaultReminderTime ?? this.defaultReminderTime,
      workingDays: workingDays ?? this.workingDays,
      workingHours: workingHours ?? this.workingHours,
    );
  }
} 