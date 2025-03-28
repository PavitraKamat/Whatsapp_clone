import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

class FireBaseOnetoonechatProvider extends ChangeNotifier {
  final UserModel user;
  List<MessageModel> _messages = [];
  bool _isTyping = false;
  bool _isReceiverTyping = false;
  String _lastSeen = "";
  TextEditingController messageController = TextEditingController();

  List<MessageModel> get messages => _messages;
  bool get isTyping => _isTyping;
  bool get isReceiverTyping => _isReceiverTyping;
  String get lastSeen => _lastSeen;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FireBaseOnetoonechatProvider({required this.user}) {
    messageController.addListener(() {
      _isTyping = messageController.text.isNotEmpty;
      notifyListeners();
    });
  }
  Future<String> getOrCreateChatId(String user1, String user2) async {
    String chatId = (user1.hashCode <= user2.hashCode)
        ? "$user1\_$user2"
        : "$user2\_$user1";

    DocumentReference chatRef =
        FirebaseFirestore.instance.collection("chats").doc(chatId);

    DocumentSnapshot chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        "chatId": chatId,
        "user1": user1,
        "user2": user2,
        "lastMessage": "",
        "lastMessageTime": DateTime.now(),
      }, SetOptions(merge: true));
    }
    return chatId;
  }

  void openChat(String user1, String user2) async {
    String chatId = await getOrCreateChatId(user1, user2);

    FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      _messages = snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
          .toList();
      notifyListeners();
    });

    String receiverId = user1 == FirebaseAuth.instance.currentUser!.uid ? user2 : user1;
    _updateReceiverLastSeen(receiverId);
    notifyListeners();
  }

  Future<void> updateLastSeen(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'lastMessageTime': Timestamp.now(),
    });
  }

Future<void> _updateReceiverLastSeen(String receiverId) async {
  try {
    var receiverDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();

    if (!receiverDoc.exists) {
      print("Document does not exist");
      _lastSeen = "Last seen recently";
      notifyListeners();
      return;
    }

    var data = receiverDoc.data();
    print("Firestore Data: $data"); 

    Timestamp? lastSeenTimestamp = data?['lastMessageTime']; // Extract Timestamp

    if (lastSeenTimestamp != null) {
      _lastSeen = "Last seen at ${DateFormat('hh:mm a').format(lastSeenTimestamp.toDate())}";
      print("Updated Last Seen: $_lastSeen"); 
    } else {
      print("lastMessageTime is null or missing");
      _lastSeen = "Last seen recently";
    }

    notifyListeners();
  } catch (e) {
    print("Error fetching last seen time: $e");
    _lastSeen = "Last seen recently"; // Fallback value
    notifyListeners();
  }
}



  Future<void> sendMessage(String user1, String user2, String text) async {
    String chatId = await getOrCreateChatId(user1, user2);
    _sendMessage(chatId, text);
  }

  Future<void> _sendMessage(String chatId, String text) async {
    String senderId = FirebaseAuth.instance.currentUser!.uid;
    // if (text.trim().isNotEmpty) {
    //   _lastSeen = "online";
    //   notifyListeners();
      //print("Sending message: '$text' to user: ${chatId}");

      String messageId = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc()
          .id;

      MessageModel newMessage = MessageModel(
        id: messageId,
        content: text.trim(),
        userId: senderId,
        timestamp: Timestamp.now().toDate(),
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(newMessage.toMap());
      notifyListeners();

      await updateLastSeen(senderId);

      messageController.clear();
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageTime': Timestamp.now(),
      });
      _updateReceiverLastSeen(chatId);
    }
  }

  // String _getCurrentTime() {
  //   return DateFormat('hh:mm a').format(DateTime.now());
  // }

  @override
  void dispose() {
    // _lastSeen = "Last seen at ${_getCurrentTime()}";
    // messageController.dispose();
    //super.dispose();
  }

