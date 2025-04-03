import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatModel {
//   final String chatId;
//   final String user1;
//   final String user2;
//   final String lastMessage;
//   final DateTime lastMessageTime;

//   ChatModel({
//     required this.chatId,
//     required this.user1,
//     required this.user2,
//     required this.lastMessage,
//     required this.lastMessageTime,
//   });
//   // Create an object from Firestore DocumentSnapshot
//   factory ChatModel.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return ChatModel(
//       chatId: data['chatId'],
//       user1: data['user1'] ?? '',
//       user2: data['user2'] ?? '',
//       lastMessage: data['lastMessage'] ?? '',
//       lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
//     );
//   }
//   // Convert the object to a Map for Firestore
//   Map<String, dynamic> toMap() {
//     return {
//       'chatId': chatId,
//       'user1': user1,
//       'user2': user2,
//       'lastMessage': lastMessage,
//       'lastMessageTime': Timestamp.fromDate(lastMessageTime),
//     };
//   }
// }

class ChatModel {
  String chatId;
  bool isGroup;
  String? groupName;
  String? groupIcon;
  String? adminId;
  List<String> users;
  String lastMessage;
  DateTime lastMessageTime;
  List<String> seenBy;
  List<String> typingUsers;
  final DateTime? createdAt;

  ChatModel({
    required this.chatId,
    required this.isGroup,
    this.groupName,
    this.groupIcon,
    this.adminId,
    required this.users,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.seenBy,
    this.createdAt,
    required this.typingUsers,
  });

  // Convert model to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      "chatId": chatId,
      "isGroup": isGroup,
      "groupName": groupName,
      "groupIcon": groupIcon,
      "adminId": adminId,
      "members": users,
      "lastMessage": lastMessage,
      "lastMessageTime": Timestamp.fromDate(lastMessageTime),
      "seenBy": seenBy,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      "typingUsers": typingUsers,
    };
  }

  // Convert Firestore document to model
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map["chatId"],
      isGroup: map["isGroup"],
      groupName: map["groupName"],
      groupIcon: map["groupIcon"],
      adminId: map["adminId"],
      users: List<String>.from(map["members"]),
      lastMessage: map["lastMessage"],
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
      seenBy: List<String>.from(map["seenBy"]),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      typingUsers: List<String>.from(map["typingUsers"]),
    );
  }
}
