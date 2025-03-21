import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sahayata.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      throw Exception('Failed to initialize database: $e');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          isCompleted INTEGER NOT NULL,
          dueDate TEXT,
          createdAt TEXT NOT NULL
        )
      ''');
    } catch (e) {
      throw Exception('Failed to create database tables: $e');
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here if needed in the future
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    try {
      final db = await database;
      return await db.insert('tasks', task);
    } catch (e) {
      throw Exception('Failed to insert task: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    try {
      final db = await database;
      return await db.query('tasks', orderBy: 'createdAt DESC');
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTasksByDate(String date) async {
    try {
      final db = await database;
      return await db.query(
        'tasks',
        where: 'dueDate = ?',
        whereArgs: [date],
        orderBy: 'createdAt DESC',
      );
    } catch (e) {
      throw Exception('Failed to get tasks by date: $e');
    }
  }

  Future<int> updateTask(Map<String, dynamic> task) async {
    try {
      final db = await database;
      return await db.update(
        'tasks',
        task,
        where: 'id = ?',
        whereArgs: [task['id']],
      );
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<int> deleteTask(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<void> close() async {
    try {
      final db = await instance.database;
      await db.close();
    } catch (e) {
      throw Exception('Failed to close database: $e');
    }
  }
} 