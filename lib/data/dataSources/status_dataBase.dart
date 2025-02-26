import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'status.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE statuses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            content TEXT,  -- Stores text or image as base64 string
            timestamp INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertStatus(Map<String, dynamic> status) async {
    final db = await database;
    await db.insert('statuses', status,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getStatuses() async {
    final db = await database;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int expiryTime = 24 * 60 * 60 * 1000; // 24 hours in milliseconds

    return await db.query(
      'statuses',
      where: 'timestamp > ?',
      whereArgs: [currentTime - expiryTime],
    );
  }

  Future<void> deleteExpiredStatuses() async {
    final db = await database;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int expiryTime = 24 * 60 * 60 * 1000;

    await db.delete(
      'statuses',
      where: 'timestamp <= ?',
      whereArgs: [currentTime - expiryTime],
    );
  }
}
