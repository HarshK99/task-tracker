import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' as sql;
import '../model/issue.dart';

class IssueDatabase {
  static const String dbName = 'issue_database.db';
  static const String issueTable = 'issues';
  static const String sectionTable = 'sections';
  static const String issueTypeTable = 'issue_types';

  static IssueDatabase? _instance;
  sql.Database? _database;

  IssueDatabase._(); // Private constructor to prevent instantiation

  static IssueDatabase get instance {
    _instance ??= IssueDatabase._();
    return _instance!;
  }

// Initialize Database Function

  Future<void> _initDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final path = p.join(dbPath, dbName);

    _database = await sql.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $issueTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            isCompleted INTEGER,
            dateTime TEXT,
            description TEXT,
            issueType TEXT,
            section TEXT,
            projectId INTEGER,
            storyPoint INTEGER,
            parentId INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE $sectionTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
      CREATE TABLE $issueTypeTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pname TEXT
      )
    ''');

        // Insert custom issue types with specified IDs
        await db.insert(issueTypeTable, {'id': 1, 'pname': 'Project'});
        await db.insert(issueTypeTable, {'id': 2, 'pname': 'Task'});
      },
    );
  }

// Issue Functions
  Future<void> insertIssue(Issue issue) async {
    await _initDatabase();
    await _database!.insert(
      issueTable,
      issue.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<void> updateIssue(Issue issue) async {
    await _initDatabase();
    await _database!.update(
      issueTable,
      issue.toMap(),
      where: 'id = ?',
      whereArgs: [issue.id],
    );
  }

  Future<void> deleteIssue(Issue issue) async {
    await _initDatabase();
    await _database!.delete(
      issueTable,
      where: 'id = ?',
      whereArgs: [issue.id],
    );
  }

  Future<List<Issue>> loadIssuesBySections(String section) async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(
      issueTable,
      where: 'section = ?',
      whereArgs: [section],
    );
    return List.generate(maps.length, (index) => Issue.fromMap(maps[index]));
  }

  Future<List<Issue>> loadAllIssues() async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(issueTable);
    return List.generate(maps.length, (index) => Issue.fromMap(maps[index]));
  }

  Future<List<Issue>> loadChildIssues(int parentId) async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(
      issueTable,
      where: 'parentId = ?',
      whereArgs: [parentId],
    );
    return List.generate(maps.length, (index) => Issue.fromMap(maps[index]));
  }

  Future<bool> hasChildIssues(int parentId) async {
    final result = await _database!.query(
      issueTable,
      where: 'parentId = ?',
      whereArgs: [parentId],
    );

    return result.isNotEmpty;
  }

// Section Functions

  Future<void> insertSection(String sectionName) async {
    await _initDatabase();
    await _database!.insert(sectionTable, {'section': sectionName});
  }

  Future<List<String>> loadSections() async {
    await _initDatabase();
    final sectionsData = await _database!.query(sectionTable);
    return sectionsData.map((data) => data['section'] as String).toList();
  }

// Close Database Function
  Future<void> closeDatabase() async {
    await _database?.close();
  }
}
