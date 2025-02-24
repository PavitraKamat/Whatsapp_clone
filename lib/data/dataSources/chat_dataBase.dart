import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/message_model.dart';

class ChatDatabase {
  static final ChatDatabase instance = ChatDatabase._init();
  static Database? _database;

  ChatDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat_messages.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contactId TEXT,
        message TEXT NOT NULL,
        isSentByUser INTEGER NOT NULL,
        time TEXT NOT NULL
      )
    ''');
  }

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

  Future<void> clearMessages() async {
    final db = await database;
    await db.delete('messages');
  }
}
