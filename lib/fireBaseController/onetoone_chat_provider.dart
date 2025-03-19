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
    _lastSeen = "Last seen at ${_getCurrentTime()}";
    //_loadMessages();

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
      if (_messages.isNotEmpty) {
        var lastMsg = _messages.last;
        _updateLastSeenFromDatabase(chatId);
      }
    });
  }

  Future<void> _updateLastSeenFromDatabase(String chatId) async {
    var lastMessageDoc = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (lastMessageDoc.docs.isNotEmpty) {
      var lastMessage = lastMessageDoc.docs.first.data();
      _lastSeen =
          "Last seen at ${DateFormat('hh:mm a').format((lastMessage['timestamp'] as Timestamp).toDate())}";
      //notifyListeners();
    } else {
      _lastSeen = "Last seen recently";
    }
    notifyListeners();
  }

  Future<void> sendMessage(String user1, String user2, String text) async {
    String chatId = await getOrCreateChatId(user1, user2);
    _sendMessage(chatId, text);
  }

  Future<void> _sendMessage(String chatId, String text) async {
    String senderId = FirebaseAuth.instance.currentUser!.uid;
    if (text.trim().isNotEmpty) {
      _lastSeen = "online";
      notifyListeners();
      print("Sending message: '$text' to user: ${chatId}");

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
        isFromCurrentUser: true,
        timestamp: Timestamp.now().toDate(),
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(newMessage.toMap());

      _messages.add(newMessage);
      notifyListeners();

      Future.delayed(Duration(seconds: 3), () async {
        MessageModel receivedMessage = MessageModel(
          id: _firestore.collection('messages').doc().id,
          content: text,
          userId: user.uid,
          isFromCurrentUser: false,
          timestamp: DateTime.now(),
        );

        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc(receivedMessage.id)
            .set(receivedMessage.toMap());

        _messages.add(receivedMessage);
        notifyListeners();
      });

      messageController.clear();

      Future.delayed(Duration(seconds: 7), () async {
        await _updateLastSeenFromDatabase(chatId);
      });

      _simulateReceiverTyping();

      final contactsProvider = Provider.of<ContactsProvider>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
        
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageTime': Timestamp.now(),
      });
    }
  }

  void _simulateReceiverTyping() {
    _isReceiverTyping = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 3), () {
      _isReceiverTyping = false;
      notifyListeners();
    });
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  @override
  void dispose() {
    _lastSeen = "Last seen at ${_getCurrentTime()}";
    messageController.dispose();
    super.dispose();
  }
}
