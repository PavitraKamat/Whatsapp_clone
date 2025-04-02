//Original one
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';
// import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

// class FireBaseOnetoonechatProvider extends ChangeNotifier {
//   final UserModel user;
//   List<MessageModel> _messages = [];
//   bool _isTyping = false;
//   bool _isReceiverTyping = false;
//   String _lastSeen = "";
//   TextEditingController messageController = TextEditingController();

//   List<MessageModel> get messages => _messages;
//   bool get isTyping => _isTyping;
//   bool get isReceiverTyping => _isReceiverTyping;
//   String get lastSeen => _lastSeen;

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   FireBaseOnetoonechatProvider({required this.user}) {
//     messageController.addListener(() {
//       _isTyping = messageController.text.isNotEmpty;
//       notifyListeners();
//     });
//   }
//   Future<String> getOrCreateChatId(String user1, String user2) async {
//     String chatId = (user1.hashCode <= user2.hashCode)
//         ? "$user1\_$user2"
//         : "$user2\_$user1";

//     DocumentReference chatRef =
//         FirebaseFirestore.instance.collection("chats").doc(chatId);

//     DocumentSnapshot chatDoc = await chatRef.get();

//     if (!chatDoc.exists) {
//       await chatRef.set({
//         "chatId": chatId,
//         "user1": user1,
//         "user2": user2,
//         "lastMessage": "",
//         "lastMessageTime": DateTime.now(),
//       }, SetOptions(merge: true));
//     }
//     return chatId;
//   }

//   void openChat(String user1, String user2) async {
//     String chatId = await getOrCreateChatId(user1, user2);

//     FirebaseFirestore.instance
//         .collection("chats")
//         .doc(chatId)
//         .collection("messages")
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .listen((snapshot) {
//       _messages = snapshot.docs
//           .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
//           .toList();
//       notifyListeners();
//     });

//     String receiverId =
//         user1 == FirebaseAuth.instance.currentUser!.uid ? user2 : user1;
//     _updateReceiverLastSeen(receiverId);
//     notifyListeners();
//   }

//   Future<void> updateLastSeen(String userId) async {
//     await _firestore.collection('users').doc(userId).update({
//       'lastMessageTime': Timestamp.now(),
//     });
//   }

//   Future<void> _updateReceiverLastSeen(String receiverId) async {
//     try {
//       var receiverDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(receiverId)
//           .get();

//       if (!receiverDoc.exists) {
//         print("Document does not exist");
//         _lastSeen = "Last seen recently";
//         notifyListeners();
//         return;
//       }

//       var data = receiverDoc.data();
//       print("Firestore Data: $data");

//       Timestamp? lastSeenTimestamp =
//           data?['lastMessageTime']; // Extract Timestamp

//       if (lastSeenTimestamp != null) {
//         _lastSeen =
//             "Last seen at ${DateFormat('hh:mm a').format(lastSeenTimestamp.toDate())}";
//         print("Updated Last Seen: $_lastSeen");
//       } else {
//         print("lastMessageTime is null or missing");
//         _lastSeen = "Last seen recently";
//       }

//       notifyListeners();
//     } catch (e) {
//       print("Error fetching last seen time: $e");
//       _lastSeen = "Last seen recently"; // Fallback value
//       notifyListeners();
//     }
//   }

//   Future<void> sendMessage(String user1, String user2, String text) async {
//     String chatId = await getOrCreateChatId(user1, user2);
//     _sendMessage(chatId, text);
//   }

//   Future<void> _sendMessage(String chatId, String text) async {
//     String senderId = FirebaseAuth.instance.currentUser!.uid;
//     // if (text.trim().isNotEmpty) {
//     //   _lastSeen = "online";
//     //   notifyListeners();
//     //print("Sending message: '$text' to user: ${chatId}");

//     String messageId = _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .doc()
//         .id;

//     MessageModel newMessage = MessageModel(
//       id: messageId,
//       content: text.trim(),
//       userId: senderId,
//       timestamp: Timestamp.now().toDate(),
//     );

//     await _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .doc(messageId)
//         .set(newMessage.toMap());
//     notifyListeners();

//     await updateLastSeen(senderId);

//     messageController.clear();
//     await _firestore.collection('chats').doc(chatId).update({
//       'lastMessage': text,
//       'lastMessageTime': Timestamp.now(),
//     });
//     _updateReceiverLastSeen(chatId);
//   }
//   // String _getCurrentTime() {
//   //   return DateFormat('hh:mm a').format(DateTime.now());
//   // }

//   @override
//   void dispose() {
//     // _lastSeen = "Last seen at ${_getCurrentTime()}";
//     // messageController.dispose();
//     //super.dispose();
//   }
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  FireBaseOnetoonechatProvider({required this.user}) {
    messageController.addListener(() {
      _isTyping = messageController.text.isNotEmpty;
      notifyListeners();
    });
  }

  Future<String> getOrCreateChatId(String senderId, String receiverId) async {
    String chatId = (senderId.hashCode <= receiverId.hashCode)
        ? "$senderId\_$receiverId"
        : "$receiverId\_$senderId";

    DocumentReference chatRef = _firestore.collection("chats").doc(chatId);
    DocumentSnapshot chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        "chatId": chatId,
        "isGroup": false,
        "users": [senderId, receiverId],
        "lastMessage": "",
        "lastMessageTime": DateTime.now(),
        "seenBy": [],
        "typingUsers": [],
        "createdAt": DateTime.now(),
      }, SetOptions(merge: true));
    }

    return chatId;
  }

  void openChat(String senderId, String receiverId) async {
    String chatId = await getOrCreateChatId(senderId, receiverId);
    _firestore.collection("chats").doc(chatId).snapshots().listen((snapshot) {
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
    });

    _updateReceiverLastSeen(receiverId);
  }

  Future<void> updateLastSeen(String userId, {bool isOnline = false}) async {
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
          if (now.difference(lastSeenDateTime).inDays == 0) {
            _lastSeen =
                "Last seen today at ${DateFormat('hh:mm a').format(lastSeenDateTime)}";
          } else if (now.difference(lastSeenDateTime).inDays == 1) {
            _lastSeen =
                "Last seen yesterday at ${DateFormat('hh:mm a').format(lastSeenDateTime)}";
          } else {
            _lastSeen =
                "Last seen on ${DateFormat('dd/MM/yyyy hh:mm a').format(lastSeenDateTime)}";
          }
        } else {
          _lastSeen = "Last seen recently";
        }
      }
      notifyListeners();
    } catch (e) {
      _lastSeen = "Last seen recently";
      notifyListeners();
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

      await updateLastSeen(senderId, isOnline: true);

      // Update chat list with last message details
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': mediaUrl ?? text,
        'lastMessageTime': Timestamp.now(),
        'seenBy': [senderId],
      });
      await updateLastSeen(senderId, isOnline: true);
      await _updateReceiverLastSeen(receiverId);
      notifyListeners();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<void> sendImageMessage(
      String senderId, String receiverId, String imagePath) async {
    try {
      File imageFile = File(imagePath);
      String fileName = "images/${DateTime.now().millisecondsSinceEpoch}.jpg";

      UploadTask uploadTask = _storage.ref(fileName).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        text: "[Image]",
        mediaUrl: downloadUrl,
        messageType: MessageType.image,
      );
    } catch (e) {
      print("Error sending image: $e");
    }
  }

  void updateTypingStatus(String chatId, String userId, bool isTyping) {
    _isTyping = isTyping;
    notifyListeners();

    FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'typingUsers': isTyping
          ? FieldValue.arrayUnion([userId])
          : FieldValue.arrayRemove([userId])
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
