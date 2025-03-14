class MessageModel {
  final int? id;
  final String contactId;
  final String message;
  final bool isSentByUser;
  final String time;
  final bool isRead;

  MessageModel({
    this.id,
    required this.contactId,
    required this.message,
    required this.isSentByUser,
    required this.time,
    this.isRead = false,
  });

  // Convert MessageModel to a Map for database storage
  Map<String, dynamic> toMap(String contactId) {
    return {
      'contactId': contactId,
      'message': message,
      'isSentByUser': isSentByUser ? 1 : 0,
      'time': time,
    };
  }

  // Create a MessageModel object from a Map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      contactId: map['contactId'],
      message: map['message']?? 'No Message',
      isSentByUser: map['isSentByUser'] == 1,
      time: map['time']?? 'No Time',
    );
  }
}

// import 'dart:convert';

// class MessageModel {
//   final String message;
//   final bool isSentByUser; 
//   final String time;

//   MessageModel({required this.message, required this.isSentByUser, required this.time});

//   Map<String, dynamic> toMap() {
//     return {
//       'message': message,
//       'isSentByUser': isSentByUser ? 1 : 0,
//       'time': time,
//     };
//   }

//   factory MessageModel.fromMap(Map<String, dynamic> map) {
//     return MessageModel(
//       message: map['message'],
//       isSentByUser: map['isSentByUser'] == 1,
//       time: map['time'],
//     );
//   }
// }

// class Chat {
//   final String contactId;
//   final List<MessageModel> chatHistory;

//   Chat({required this.contactId, required this.chatHistory});

//   Map<String, dynamic> toMap() {
//     return {
//       'contact_id': contactId,
//       'chat_history': jsonEncode(chatHistory.map((msg) => msg.toMap()).toList()),
//     };
//   }

//   factory Chat.fromMap(Map<String, dynamic> map) {
//     return Chat(
//       contactId: map['contact_id'],
//       chatHistory: (jsonDecode(map['chat_history']) as List)
//           .map((msg) => MessageModel.fromMap(msg))
//           .toList(),
//     );
//   }
// }

