import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' as sql;
import '../model/task.dart';

class TaskDatabase {
  static const String dbName = 'task_database.db';
  static const String taskTable = 'tasks';
  static const String sectionTable = 'sections';

  static TaskDatabase? _instance;
  sql.Database? _database;

  TaskDatabase._(); // Private constructor to prevent instantiation

  static TaskDatabase get instance {
    _instance ??= TaskDatabase._();
    return _instance!;
  }

  Future<void> _initDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final path = p.join(dbPath, dbName);

    _database = await sql.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $taskTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            isCompleted INTEGER,
            dateTime TEXT,
            description TEXT,
            parentSection TEXT,
            section TEXT,
            parentId INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE $sectionTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            parentSection TEXT,
            name TEXT
            
          )
        ''');
      },
    );
  }

  Future<void> insertTask(Task task) async {
    await _initDatabase();
    await _database!.insert(
      taskTable,
      task.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
    await _initDatabase();
    await _database!.update(
      taskTable,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(Task task) async {
    await _initDatabase();
    await _database!.delete(
      taskTable,
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<List<Task>> loadTasksBySections(String parentSection, String section) async {
      await _initDatabase();
      final List<Map<String, dynamic>> maps = await _database!.query(
        taskTable,
        where: 'parentSection = ? AND section = ?',
        whereArgs: [parentSection, section],
      );
      return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
    }

  Future<List<Task>> loadAllTodayTasks(String parentSection) async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(
      taskTable,
      where: 'parentSection = ?',
      whereArgs: [parentSection],
    );
    return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
  }
  Future<List<Task>> loadChildTasks(int parentId) async {
      await _initDatabase();
      final List<Map<String, dynamic>> maps = await _database!.query(
        taskTable,
        where: 'parentId = ?',
        whereArgs: [parentId],
      );
      return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
    }
  Future<bool> hasChildTasks(int parentId) async {
    final result = await _database!.query(
      taskTable,
      where: 'parentId = ?',
      whereArgs: [parentId],
    );

    return result.isNotEmpty;
  }


  Future<void> insertSection(String sectionName) async {
    await _initDatabase();
    await _database!.insert(sectionTable, {'section': sectionName});
  }


  Future<List<String>> loadSections() async {
    await _initDatabase();
    final sectionsData = await _database!.query(sectionTable);
    return sectionsData.map((data) => data['section'] as String).toList();
  }



  Future<void> closeDatabase() async {
    await _database?.close();
  }
}
