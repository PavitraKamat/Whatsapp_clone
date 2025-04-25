// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:wtsp_clone/fireBaseHelper/chat_id_helper.dart';
// import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';

// class ChatRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<void> createChatIfNotExists(String senderId, String receiverId) async {
//     String chatId = ChatIdHelper.generateChatId(senderId, receiverId);
//     DocumentReference chatRef = _firestore.collection("chats").doc(chatId);
//     DocumentSnapshot chatDoc = await chatRef.get();

//     if (!chatDoc.exists) {
//       await chatRef.set({
//         "chatId": chatId,
//         "isGroup": false,
//         "users": [senderId, receiverId],
//         "lastMessage": "",
//         "lastMessageTime": DateTime.now(),
//         "seenBy": [],
//         "typingUsers": [],
//         "createdAt": DateTime.now(),
//       });
//     }
//   }

//   Future<void> updateTypingStatus(String chatId, String userId, bool isTyping) async {
//     try {
//       await _firestore.collection('chats').doc(chatId).update({
//         'typingUsers': isTyping
//             ? FieldValue.arrayUnion([userId])
//             : FieldValue.arrayRemove([userId])
//       });
//     } catch (e) {
//       print("Error updating typing status: $e");
//     }
//   }

//   Future<void> updateLastSeen(String userId, {bool isOnline = false}) async {
//     try {
//       await _firestore.collection('users').doc(userId).update({
//         'isOnline': isOnline,
//         'lastSeen': isOnline ? 'online' : Timestamp.now(),
//       });
//     } catch (e) {
//       print("Error updating online status: $e");
//     }
//   }

//   Future<String> getUserLastSeen(String userId) async {
//     try {
//       DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      
//       if (!userDoc.exists) return "Last seen recently";
      
//       var data = userDoc.data() as Map<String, dynamic>;
      
//       if (data.containsKey('isOnline') && data['isOnline'] == true) {
//         return "Online";
//       } else if (data.containsKey('lastSeen') && data['lastSeen'] is Timestamp) {
//         Timestamp lastSeenTimestamp = data['lastSeen'];
//         DateTime lastSeenDateTime = lastSeenTimestamp.toDate();
//         DateTime now = DateTime.now();

//         // Extracting only date components
//         DateTime lastSeenDate = DateTime(
//           lastSeenDateTime.year,
//           lastSeenDateTime.month,
//           lastSeenDateTime.day,
//         );

//         DateTime todayDate = DateTime(now.year, now.month, now.day);
//         DateTime yesterdayDate = todayDate.subtract(Duration(days: 1));

//         if (lastSeenDate == todayDate) {
//           return "Last seen today at ${DateFormat('hh:mm a').format(lastSeenDateTime)}";
//         } else if (lastSeenDate == yesterdayDate) {
//           return "Last seen yesterday at ${DateFormat('hh:mm a').format(lastSeenDateTime)}";
//         } else {
//           return "Last seen on ${DateFormat('dd/MM/yyyy').format(lastSeenDateTime)}";
//         }
//       }
//       return "Last seen recently";
//     } catch (e) {
//       print("Error getting last seen: $e");
//       return "Last seen recently";
//     }
//   }

//   Stream<List<MessageModel>> getMessagesStream(String senderId, String receiverId) {
//     String chatId = ChatIdHelper.generateChatId(senderId, receiverId);
//     return _firestore
//       .collection("chats")
//       .doc(chatId)
//       .collection("messages")
//       .orderBy('timestamp', descending: false)
//       .snapshots()
//       .map((snapshot) {
//         String currentUserId = FirebaseAuth.instance.currentUser!.uid;
//         return snapshot.docs
//           .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
//           .where((message) => !(message.deletedFor.contains(currentUserId)))
//           .toList();
//       });
//   }

//   Stream<bool> getTypingStatusStream(String senderId, String receiverId) {
//     String chatId = ChatIdHelper.generateChatId(senderId, receiverId);
//     return _firestore
//       .collection("chats")
//       .doc(chatId)
//       .snapshots()
//       .map((snapshot) {
//         if (!snapshot.exists) return false;
        
//         List<dynamic> typingUsers = snapshot.data()?['typingUsers'] ?? [];
//         return typingUsers.contains(receiverId);
//       });
//   }

//   Future<void> markMessageAsRead(String chatId, String messageId) async {
//     await _firestore
//       .collection('chats')
//       .doc(chatId)
//       .collection('messages')
//       .doc(messageId)
//       .update({'isRead': true});
//   }

//   Future<String> uploadFile(File file, String path, String contentType) async {
//     final ref = _storage.ref().child(path);
//     final metadata = SettableMetadata(contentType: contentType);
//     final uploadTask = await ref.putFile(file, metadata);
//     return await uploadTask.ref.getDownloadURL();
//   }

//   Future<void> sendMessage(MessageModel message) async {
//     await _firestore
//       .collection('chats')
//       .doc(message.chatId)
//       .collection('messages')
//       .doc(message.messageId)
//       .set(message.toMap());
      
//     // Update chat list with last message details
//     await _firestore.collection('chats').doc(message.chatId).update({
//       'lastMessage': message.messageContent,
//       'lastMessageType': message.messageType.name,
//       'lastMessageTime': Timestamp.fromDate(message.timestamp),
//       'seenBy': [message.senderId, message.receiverId],
//     });
//   }

//   Future<void> updateMessage(String chatId, String messageId, Map<String, dynamic> data) async {
//     await _firestore
//       .collection('chats')
//       .doc(chatId)
//       .collection('messages')
//       .doc(messageId)
//       .update(data);
//   }

//   Future<void> deleteMessageForMe(String messageId, String chatId, String userId) async {
//     await _firestore
//       .collection('chats')
//       .doc(chatId)
//       .collection('messages')
//       .doc(messageId)
//       .update({
//         'deletedFor': FieldValue.arrayUnion([userId])
//       });
//   }

//   Future<void> deleteMessageForEveryone(String messageId, String chatId) async {
//     await _firestore
//       .collection('chats')
//       .doc(chatId)
//       .collection('messages')
//       .doc(messageId)
//       .update({
//         'isDeletedForEveryone': true,
//         'mediaUrl': null
//       });
//   }

//   Future<void> updateLastMessageInChat(String chatId, String userId) async {
//     // Fetch the last visible (non-deleted) message for this user
//     QuerySnapshot newLastMessagesSnapshot = await _firestore
//       .collection('chats')
//       .doc(chatId)
//       .collection('messages')
//       .orderBy('timestamp', descending: true)
//       .get();

//     MessageModel? newLastMessage;

//     for (var doc in newLastMessagesSnapshot.docs) {
//       var messageData = doc.data() as Map<String, dynamic>;
//       List<dynamic> deletedFor = messageData['deletedFor'] ?? [];
//       if (!deletedFor.contains(userId)) {
//         newLastMessage = MessageModel.fromMap(doc.id, messageData);
//         break;
//       }
//     }

//     if (newLastMessage != null) {
//       await _firestore.collection('chats').doc(chatId).update({
//         'lastMessage': newLastMessage.messageContent,
//         'lastMessageType': newLastMessage.messageType.name,
//         'lastMessageTime': Timestamp.fromDate(newLastMessage.timestamp),
//         'seenBy': [userId],
//       });
//     } else {
//       await _firestore.collection('chats').doc(chatId).update({
//         'lastMessage': '',
//         'lastMessageType': 'text',
//         'lastMessageTime': null,
//         'seenBy': [],
//       });
//     }
//   }
// }