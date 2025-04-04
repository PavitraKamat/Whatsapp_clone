import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  ScrollController scrollController = ScrollController();
  bool _isActive = true;
  bool _isSelectionMode = false;
  List<String> _selectedMessageIds = [];

  List<MessageModel> get messages => _messages;
  bool get isTyping => _isTyping;
  bool get isReceiverTyping => _isReceiverTyping;
  String get lastSeen => _lastSeen;
  bool get isSelectionMode => _isSelectionMode;
  List<String> get selectedMessageIds => _selectedMessageIds;


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  FireBaseOnetoonechatProvider({required this.user}) {
    messageController.addListener(() async {
      if (!_isActive) return;

      bool currentlyTyping = messageController.text.isNotEmpty;
      if (currentlyTyping != _isTyping) {
        _isTyping = currentlyTyping;
        String senderId = FirebaseAuth.instance.currentUser!.uid;
        String chatId = await getOrCreateChatId(senderId, user.uid);
        updateTypingStatus(chatId, senderId, _isTyping);
      }
      notifyListeners();
    });
  }

  void scrollToBottom() {
    if (!_isActive) return;

    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_isActive && scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void toggleSelectionMode(bool value) {
    _isSelectionMode = value;
    if (!value) _selectedMessageIds.clear(); 
    notifyListeners();
  }

  void toggleMessageSelection(String messageId) {
    if (_selectedMessageIds.contains(messageId)) {
      _selectedMessageIds.remove(messageId);
    } else {
      _selectedMessageIds.add(messageId);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedMessageIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }


  Future<String> getOrCreateChatId(String senderId, String receiverId) async {
    try {
      String chatId = (senderId.hashCode <= receiverId.hashCode)
          ? "$senderId\_$receiverId"
          : "$receiverId\_$senderId";

      DocumentReference chatRef = _firestore.collection("chats").doc(chatId);
      DocumentSnapshot chatDoc = await chatRef.get();

      if (!chatDoc.exists) {
        await chatRef.set({
          "chatId": chatId,
          "isGroup": false,
          //"users": List<String>.from([senderId, receiverId]),
          "users": [senderId, receiverId],
          "lastMessage": "",
          "lastMessageTime": DateTime.now(),
          "seenBy": [],
          "typingUsers": [],
          "createdAt": DateTime.now(),
        }, SetOptions(merge: true));
      }

      return chatId;
    } catch (e, stacktrace) {
      print("Error in getOrCreateChatId: $e");
      print(stacktrace);
      return "";
    }
  }

  void openChat(String senderId, String receiverId) async {
    if (!_isActive) return;
    String chatId = await getOrCreateChatId(senderId, receiverId);
    if (chatId.isEmpty) {
      print("Error: chatId is empty");
      return;
    }
    _firestore.collection("chats").doc(chatId).snapshots().listen((snapshot) {
      if (!_isActive) return;

      if (snapshot.exists) {
        List<dynamic> typingUsers = snapshot.data()?['typingUsers'] ?? [];
        _isReceiverTyping = typingUsers.contains(receiverId);
        notifyListeners();
      }
    });
    _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) async {
      if (!_isActive) return;
      _messages = snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
          .toList();

      for (var message in _messages) {
        if (message.receiverId == senderId && !message.isRead) {
          await _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .doc(message.messageId)
              .update({'isRead': true});
        }
      }
      notifyListeners();
      scrollToBottom();
    });
    await _updateReceiverLastSeen(receiverId);
  }

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

  Future<void> _updateReceiverLastSeen(String receiverId) async {
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

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
    String? mediaUrl,
    MessageType messageType = MessageType.text,
  }) async {
    try {
      String chatId = await getOrCreateChatId(senderId, receiverId);
      if (chatId.isEmpty) {
        print("Error: chatId is empty");
        return;
      }
      String messageId = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc()
          .id;
      DocumentSnapshot receiverDoc =
          await _firestore.collection('users').doc(receiverId).get();
      bool isReceiverOnline = receiverDoc.exists &&
          (receiverDoc.data() as Map<String, dynamic>)['isOnline'] == true;
      MessageModel newMessage = MessageModel(
        messageId: messageId,
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        messageType: messageType,
        messageContent: text,
        mediaUrl: mediaUrl,
        timestamp: DateTime.now(),
        isRead: false,
        isDelivered: isReceiverOnline,
        seenBy: [],
        isDeleted: false,
      );
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(newMessage.toMap());
      print("Message sent successfully!");
      await updateLastSeen(senderId, isOnline: true);
      await _updateReceiverLastSeen(receiverId);
      // Update chat list with last message details
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageType': messageType.name,
        'lastMessageTime': Timestamp.now(),
        'seenBy': [senderId],
      });
      notifyListeners();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<void> sendImageMessage(
      String senderId, String receiverId, String imagePath) async {
    if (!_isActive) return;
    try {
      File imageFile = File(imagePath);
      String fileName = "images/${DateTime.now().millisecondsSinceEpoch}.jpg";

      UploadTask uploadTask = _storage.ref(fileName).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        text: "📷 Photo",
        mediaUrl: downloadUrl,
        messageType: MessageType.image,
      );
      await updateLastSeen(senderId, isOnline: true);
    } catch (e) {
      print("Error sending image: $e");
    }
  }

  void updateTypingStatus(String chatId, String userId, bool isTyping) async {
    if (!_isActive) return;
    try {
      _isTyping = isTyping;
      notifyListeners();

      await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        'typingUsers': isTyping
            ? FieldValue.arrayUnion([userId])
            : FieldValue.arrayRemove([userId])
      });
      print("Typing status updated: $_isTyping for chatId: $chatId");
    } catch (e) {
      print("Error updating typing status: $e");
    }
  }

  @override
  void dispose() {
    _isActive = false;
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
