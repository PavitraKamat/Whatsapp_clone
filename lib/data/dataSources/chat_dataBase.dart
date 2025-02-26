import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/message_model.dart';

class ChatDatabase {
  static final ChatDatabase instance = ChatDatabase._init();
  static Database? _database;

  ChatDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await getDatabase();
    return _database!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "chat_messages.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contactId TEXT,
        message TEXT NOT NULL,
        isSentByUser INTEGER NOT NULL,
        time TEXT NOT NULL
      )
    ''');
      },
    );
    return database;
  }

  // Future<void> _createDB(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE messages (
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       contactId TEXT,
  //       message TEXT NOT NULL,
  //       isSentByUser INTEGER NOT NULL,
  //       time TEXT NOT NULL
  //     )
  //   ''');
  // }

  Future<int> insertMessage(MessageModel message, String contactId) async {
    final db = await database;
    return await db.insert(
      'messages',
      message.toMap(contactId),
      //conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MessageModel>> getMessages(String contactId) async {
    final db = await database;
    final result = await db.query(
      'messages',
      where: 'contactId = ?',
      whereArgs: [contactId],
    );

    return result.map((json) => MessageModel.fromMap(json)).toList();
  }

  Future<Map<String, String>?> getLastMessage(String contactId) async {
    final db = await database;
    final result = await db.query(
      'messages',
      where: 'contactId = ?',
      whereArgs: [contactId],
      orderBy: 'time DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return {
        'message': result.first['message'] as String,
        'time': result.first['time'] as String,
      };
    }
    return null;
  }

  Future<MessageModel?> getLastReceivedMessage(String contactId) async {
    final db = await database;
    final result = await db.query(
      'messages',
      where: 'contactId = ? AND isSentByUser = 0',
      whereArgs: [contactId],
      orderBy: 'time DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return MessageModel.fromMap(result.first);
    }
    return null;
  }

  Future<void> clearMessages() async {
    final db = await database;
    await db.delete('messages');
  }
}
