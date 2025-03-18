import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';

class FirebaseOnetoonechatProvider extends ChangeNotifier {
  final String chatId;
  final String currentUserId;
  List<MessageModel> _messages = [];
  bool _isTyping = false;
  bool _isReceiverTyping = false;
  String _lastSeen = "Last seen at ${_getCurrentTime()}";

  TextEditingController messageController = TextEditingController();

  List<MessageModel> get messages => _messages;
  bool get isTyping => _isTyping;
  bool get isReceiverTyping => _isReceiverTyping;
  String get lastSeen => _lastSeen;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseOnetoonechatProvider({required this.chatId, required this.currentUserId}) {
    _listenToMessages();
    _listenToLastSeen();
    messageController.addListener(() {
      _isTyping = messageController.text.isNotEmpty;
      notifyListeners();
    });
  }

  /// Listen to messages in real-time
  void _listenToMessages() {
    _firestore
        .collection('messages')
        .doc(chatId)
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _messages = snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList()
          .reversed
          .toList();
      notifyListeners();
    });
  }

  /// **Listen to last seen status**
  void _listenToLastSeen() {
    _firestore.collection('users').doc(chatId).snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        _lastSeen = snapshot.data()!['lastSeen'] ?? "Last seen recently";
        notifyListeners();
      }
    });
  }

  /// **Send Message**
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _lastSeen = "online";
    notifyListeners();

    String messageId = _firestore.collection('messages').doc(chatId).collection('chat').doc().id;

    MessageModel newMessage = MessageModel(
      id: messageId,
      userId: currentUserId,
      content: text.trim(),
      isFromCurrentUser: true,
      timestamp: DateTime.now(),
    );

    await _firestore.collection('messages').doc(chatId).collection('chat').doc(messageId).set(newMessage.toMap());

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text.trim(),
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    messageController.clear();
    notifyListeners();

    Future.delayed(Duration(seconds: 7), _updateLastSeen);
    _simulateReceiverTyping();
  }

  /// **Update Last Seen**
  Future<void> _updateLastSeen() async {
    await _firestore.collection('users').doc(currentUserId).update({
      'lastSeen': "Last seen at ${_getCurrentTime()}",
    });
    notifyListeners();
  }

  /// **Simulate Receiver Typing**
  void _simulateReceiverTyping() {
    _isReceiverTyping = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 3), () {
      _isReceiverTyping = false;
      notifyListeners();
    });
  }

  /// **Get Current Time**
  static String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  @override
  void dispose() {
    _lastSeen = "Last seen at ${_getCurrentTime()}";
    messageController.dispose();
    super.dispose();
  }
}
