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

//Second one
// class ChatController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Get current user ID
//   String get currentUserId => _auth.currentUser!.uid;

//   // Send Message
//   Future<void> sendMessage(
//       {required String receiverId,
//       required String message,
//       required MessageType type}) async {
//     try {
//       String chatId = _getChatId(currentUserId, receiverId);
//       DocumentReference chatRef = _firestore.collection("chats").doc(chatId);

//       MessageModel newMessage = MessageModel(
//         messageId: _firestore.collection("messages").doc().id,
//         chatId: chatId,
//         senderId: currentUserId,
//         receiverId: receiverId,
//         messageType: type,
//         messageContent: message,
//         timestamp: DateTime.now(),
//         isRead: false,
//         isDelivered: false,
//         seenBy: [],
//         isDeleted: false,
//       );

//       await chatRef
//           .collection("messages")
//           .doc(newMessage.messageId)
//           .set(newMessage.toMap());

//       // Update Last Message in Chat List
//       await chatRef.set(
//         {
//           "lastMessage": message,
//           "lastMessageTime": DateTime.now().toIso8601String(),
//           "seenBy": [],
//           "typingUsers": [],
//         },
//         SetOptions(merge: true),
//       );
//     } catch (e) {
//       print("Error sending message: $e");
//     }
//   }

//   // Get Messages Stream
//   Stream<List<MessageModel>> getMessages(String receiverId) {
//     String chatId = _getChatId(currentUserId, receiverId);
//     return _firestore
//         .collection("chats")
//         .doc(chatId)
//         .collection("messages")
//         .orderBy("timestamp", descending: false)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
//             .toList());
//   }

//   // Mark Messages as Read
//   Future<void> markMessagesAsRead(String receiverId) async {
//     String chatId = _getChatId(currentUserId, receiverId);
//     QuerySnapshot messages = await _firestore
//         .collection("chats")
//         .doc(chatId)
//         .collection("messages")
//         .where("receiverId", isEqualTo: currentUserId)
//         .where("isRead", isEqualTo: false)
//         .get();

//     for (var doc in messages.docs) {
//       await doc.reference.update({"isRead": true});
//     }
//   }

//   // Update Typing Status
//   Future<void> updateTypingStatus(String receiverId, bool isTyping) async {
//     String chatId = _getChatId(currentUserId, receiverId);
//     await _firestore.collection("chats").doc(chatId).set({
//       "typingUsers": isTyping ? [currentUserId] : [],
//     }, SetOptions(merge: true));
//   }

import 'package:cloud_firestore/cloud_firestore.dart';
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

    _firestore
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
          _lastSeen =
              "Last seen at ${DateFormat('hh:mm a').format(lastSeenTimestamp.toDate())}";
        } else {
          _lastSeen = "Last seen recently";
        }
      }
      notifyListeners();
    } catch (e) {
      _lastSeen = "Last seen recently"; // Fallback in case of an error
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
      // Get or create a chat ID for the users
      String chatId = await getOrCreateChatId(senderId, receiverId);

      // Generate a unique message ID
      String messageId = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc()
          .id;

      // Create message model
      MessageModel newMessage = MessageModel(
        messageId: messageId,
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        messageType: messageType,
        messageContent: text,
        timestamp: DateTime.now(),
        isRead: false,
        isDelivered: false,
        seenBy: [], // Initially, no one has seen it
        isDeleted: false,
      );

      // Save message in Firestore
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(newMessage.toMap());

      await updateLastSeen(senderId, isOnline: true);

      // Update chat list with last message details
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': text, // Show message type if media
        'lastMessageTime': Timestamp.now(),
        'seenBy': [senderId],
      });
      await updateLastSeen(senderId, isOnline: true);
      // Notify receiver's last seen status
      await _updateReceiverLastSeen(receiverId);
      notifyListeners();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}

// Future<void> sendMessage({
//   required String senderId,
//   required String receiverId,
//   required String text, // For text messages
//   String? mediaUrl, // URL for images or videos
//   MessageType messageType = MessageType.text,
//   required File? mediaFile, // For image/video files
// }) async {
//   try {
//     // Get or create a chat ID for the users
//     String chatId = await getOrCreateChatId(senderId, receiverId);

//     // Generate a unique message ID
//     String messageId = _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .doc()
//         .id;

//     // If the message is not a text, we need to upload the media first
//     String? uploadedMediaUrl;
//     if (messageType == MessageType.image || messageType == MessageType.video) {
//       if (mediaFile != null) {
//         // Upload the media (image/video)
//         uploadedMediaUrl = await uploadMediaToFirebaseStorage(senderId, mediaFile, messageType);
//       } else {
//         print("No media file provided for $messageType");
//         return;
//       }
//     }

//     // Create message model
//     MessageModel newMessage = MessageModel(
//       messageId: messageId,
//       chatId: chatId,
//       senderId: senderId,
//       receiverId: receiverId,
//       messageType: messageType,
//       messageContent: messageType == MessageType.text ? text : "", // Only send text for text messages
//       timestamp: DateTime.now(),
//       isRead: false,
//       isDelivered: false,
//       seenBy: [], // Initially, no one has seen it
//       isDeleted: false,
//     );

//     // If there is a media URL, update the message content with the URL
//     if (uploadedMediaUrl != null) {
//       newMessage = newMessage.copyWith(
//         messageContent: uploadedMediaUrl, // Replace text content with media URL
//       );
//     }

//     // Save message in Firestore
//     await _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .doc(messageId)
//         .set(newMessage.toMap());

//     await updateLastSeen(senderId, isOnline: true);

//     // Update chat list with last message details
//     await _firestore.collection('chats').doc(chatId).update({
//       'lastMessage': messageType == MessageType.text ? text : "Sent a ${messageType.name}",
//       'lastMessageTime': Timestamp.now(),
//       'seenBy': [senderId],
//     });

//     // Notify receiver's last seen status
//     await _updateReceiverLastSeen(receiverId);
//     notifyListeners();
//   } catch (e) {
//     print("Error sending message: $e");
//   }
// }

// // Helper method to upload media to Firebase Storage
// Future<String?> uploadMediaToFirebaseStorage(String senderId, File mediaFile, MessageType messageType) async {
//   try {
//     // Define the storage path (using a unique identifier for each media)
//     String filePath = 'chats/${senderId}/${messageType.name}/${DateTime.now().millisecondsSinceEpoch}_${mediaFile.uri.pathSegments.last}';
    
//     // Get a reference to Firebase Storage
//     final Reference storageReference = FirebaseStorage.instance.ref().child(filePath);

//     // Upload file to Firebase Storage
//     UploadTask uploadTask = storageReference.putFile(mediaFile);

//     // Get download URL once the upload is complete
//     TaskSnapshot snapshot = await uploadTask;
//     String downloadUrl = await snapshot.ref.getDownloadURL();

//     return downloadUrl; // Return the media URL
//   } catch (e) {
//     print("Error uploading media: $e");
//     return null; // Return null if the upload fails
//   }
// }
