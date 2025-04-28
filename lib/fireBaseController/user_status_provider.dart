// User Status Provider - Handles user status, typing indicators, last seen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wtsp_clone/fireBaseHelper/chat_id_helper.dart';

class UserStatusProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isTyping = false;
  bool _isReceiverTyping = false;
  String _lastSeen = "";
  TextEditingController messageController = TextEditingController();
  bool _isActive = true;
  
  bool get isTyping => _isTyping;
  bool get isReceiverTyping => _isReceiverTyping;
  String get lastSeen => _lastSeen;
  
  UserStatusProvider() {
    messageController.addListener(() async {
      if (!_isActive) return;

      bool currentlyTyping = messageController.text.isNotEmpty;
      if (currentlyTyping != _isTyping) {
        _isTyping = currentlyTyping;
        String senderId = FirebaseAuth.instance.currentUser!.uid;
        String chatId = ChatIdHelper.generateChatId(senderId, messageController.text);
        updateTypingStatus(chatId, senderId, _isTyping);
      }
      notifyListeners();
    });
  }
  
  // Monitor typing status of receiver
  void listenToTypingStatus(String chatId, String receiverId) {
    if (!_isActive) return;
    
    _firestore.collection("chats").doc(chatId).snapshots().listen((snapshot) {
      if (!_isActive) return;

      if (snapshot.exists) {
        List<dynamic> typingUsers = snapshot.data()?['typingUsers'] ?? [];
        _isReceiverTyping = typingUsers.contains(receiverId);
        notifyListeners();
      }
    });
  }
  
  // Update online/offline status
  Future<void> updateLastSeen(String userId, {bool isOnline = false}) async {
    if (!_isActive) return;
    try {
      await _firestore.collection('users').doc(userId).update({
        'isOnline': isOnline,
        'lastSeen': isOnline ? 'online' : Timestamp.now(),
      });
      notifyListeners();
    } catch (e) {
      print("Error updating online status: $e");
    }
  }

  // Get last seen status of another user
  Future<void> updateReceiverLastSeen(String receiverId) async {
    if (!_isActive) return;
    try {
      DocumentSnapshot receiverDoc =
          await _firestore.collection('users').doc(receiverId).get();

      if (!receiverDoc.exists) {
        _lastSeen = "Last seen recently";
      } else {
        var data = receiverDoc.data() as Map<String, dynamic>;

        // Check online status
        if (data.containsKey('isOnline') && data['isOnline'] == true) {
          _lastSeen = "Online";
        } else if (data.containsKey('lastSeen') &&
            data['lastSeen'] is Timestamp) {
          Timestamp lastSeenTimestamp = data['lastSeen'];
          DateTime lastSeenDateTime = lastSeenTimestamp.toDate();
          DateTime now = DateTime.now();

          // Extracting only date components
          DateTime lastSeenDate = DateTime(
            lastSeenDateTime.year,
            lastSeenDateTime.month,
            lastSeenDateTime.day,
          );

          DateTime todayDate = DateTime(now.year, now.month, now.day);
          DateTime yesterdayDate = todayDate.subtract(Duration(days: 1));

          if (lastSeenDate == todayDate) {
            _lastSeen =
                "Last seen today at ${DateFormat('hh:mm a').format(lastSeenDateTime)}";
          } else if (lastSeenDate == yesterdayDate) {
            _lastSeen =
                "Last seen yesterday at ${DateFormat('hh:mm a').format(lastSeenDateTime)}";
          } else {
            _lastSeen =
                "Last seen on ${DateFormat('dd/MM/yyyy').format(lastSeenDateTime)}";
          }
        } else {
          _lastSeen = "Last seen recently";
        }
      }
      notifyListeners();
    } catch (e, stacktrace) {
      _lastSeen = "Last seen recently";
      print(stacktrace);
    }
  }
  
  // Update typing status in Firestore
  void updateTypingStatus(String chatId, String userId, bool isTyping) async {
    if (!_isActive) return;
    try {
      _isTyping = isTyping;
      notifyListeners();

      await _firestore.collection('chats').doc(chatId).update({
        'typingUsers': isTyping
            ? FieldValue.arrayUnion([userId])
            : FieldValue.arrayRemove([userId])
      });
    } catch (e) {
      print("Error updating typing status: $e");
    }
  }

  void updateTypingStatusFromText(String text) {
    _isTyping = text.isNotEmpty;
    notifyListeners();
  }

  void resetTyping() {
    _isTyping = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _isActive = false;
    messageController.dispose();
    super.dispose();
  }
}