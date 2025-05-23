import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String chatId;
  bool isGroup;
  String? groupName;
  String? groupIcon;
  String? adminId;
  List<String> users;
  String lastMessage;
  String lastMessageType;
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
    required this.lastMessageType,
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
      "lastMessageType": lastMessageType,
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
      lastMessageType: map["lastMessageType"] ?? "text",
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
      seenBy: List<String>.from(map["seenBy"]),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      typingUsers: List<String>.from(map["typingUsers"]),
    );
  }
}
