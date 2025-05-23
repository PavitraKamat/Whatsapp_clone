// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/message_model.dart';
 
// class WtspDb {
//   static final WtspDb instance = WtspDb._init();
//   static Database? _database;
 
//   WtspDb._init();
 
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await getDatabase();
//     return _database!;
//   }
 
//   Future<Database> getDatabase() async {
//     final databaseDirPath = await getDatabasesPath();
//     final databasePath = join(databaseDirPath, "Whatsapp.db");
 
//     final database = await openDatabase(
//       databasePath,
//       version: 1, 
//       onCreate: (db, version) {
//         db.execute('''
//         CREATE TABLE messages (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           contactId TEXT,
//           message TEXT NOT NULL,
//           isSentByUser INTEGER NOT NULL,
//           time TEXT NOT NULL
//         )
//       ''');
//         db.execute('''
//         CREATE TABLE profile (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           name TEXT NOT NULL,
//           status TEXT NOT NULL,
//           imagePath TEXT
//         )
//       ''');
//       },
//     );
//     return database;
//   }
 
//   Future<int> insertMessage(MessageModel message, String contactId) async {
//   final db = await database;
//   int result = await db.insert(
//     'messages',
//     message.toMap(contactId),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );

//   if (result > 0) {
//     print("Message successfully inserted into DB: '${message.message}' at ${message.time}");
//   } else {
//     print("Failed to insert message into DB.");
//   }

//   return result;
// }
//   Future<List<MessageModel>> getMessages(String contactId) async {
//   final db = await database;
//   final result = await db.query(
//     'messages',
//     where: 'contactId = ?',
//     whereArgs: [contactId],
//   );

//   if (result.isNotEmpty) {
//     print("Fetched ${result.length} messages from DB for contact $contactId.");
//     for (var msg in result) {
//       print("Message: '${msg['message']}' at ${msg['time']}");
//     }
//   } else {
//     print("No messages found for contact $contactId.");
//   }

//   return result.map((json) => MessageModel.fromMap(json)).toList();
// }

//   Future<MessageModel?> getLastReceivedMessage(String contactId) async {
//     final db = await database;
//     final result = await db.query(
//       'messages',
//       where: 'contactId = ? AND isSentByUser = 0',
//       whereArgs: [contactId],
//       orderBy: 'time DESC',
//       limit: 1,
//     );
 
//     if (result.isNotEmpty) {
//       return MessageModel.fromMap(result.first);
//     }
//     return null;
//   }
 
//   Future<void> clearMessages() async {
//     final db = await database;
//     await db.delete('messages');
//   }
 
//   Future<int> saveProfile(String name, String status, String imagePath) async {
//     final db = await database;
//     final result = await db.query('profile', limit: 1);
 
//     if (result.isNotEmpty) {
//       return await db.update(
//         'profile',
//         {'name': name, 'status': status, 'imagePath': imagePath},
//         where: "id = ?",
//         whereArgs: [result.first['id']],
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     } else {
//       return await db.insert(
//         'profile',
//         {'name': name, 'status': status, 'imagePath': imagePath},
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     }
//   }
 
//   Future<Map<String, dynamic>> getProfile() async {
//     final db = await database;
//     final result = await db.query('profile', limit: 1);
 
//     if (result.isNotEmpty) {
//       return {
//         'name': result.first['name'] as String? ?? "Alice",
//         'status': result.first['status'] as String? ??
//             "Hey there! I'm using WhatsApp",
//         'imagePath': result.first['imagePath'] as String?,
//       };
//     }
//     return {
//       'name': "Alice",
//       'status': "Hey there! I'm using WhatsApp",
//       'imagePath': '',
//     };
//   }
 
//   static Future<String?> pickAndSaveImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
 
//     if (pickedFile == null) return null;
 
//     final Directory appDir = await getApplicationDocumentsDirectory();
//     final String newPath = '${appDir.path}/${pickedFile.name}';
 
//     File imageFile = File(pickedFile.path);
//     await imageFile.copy(newPath);
 
//     return newPath;
//   }
 
//   Future<void> clearProfile() async {
//     final db = await database;
//     await db.delete('profile');
//   }
// }