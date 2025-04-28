// Message Provider - Handles message sending, deleting, and media operations
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wtsp_clone/fireBaseHelper/chat_id_helper.dart';
import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';

class MessageProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<MessageModel> _messages = [];
  
  List<MessageModel> get messages => _messages;
  
  // Audio recording related properties and methods
  bool isRecording = false;
  bool isCancelled = false;
  int recordDuration = 0;
  FlutterSoundRecorder? _recorder;
  String? recordedFilePath;
  Timer? _timer;
  
  // Create chat document if it doesn't exist
  Future<void> createChatIfNotExists(String senderId, String receiverId) async {
    String chatId = ChatIdHelper.generateChatId(senderId, receiverId);
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
      });
    }
  }
  
  // Load messages for a chat
  Future<void> loadMessages(String chatId, String currentUserId) async {
    _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) async {
      _messages = snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
          .where((message) => !(message.deletedFor.contains(currentUserId)))
          .toList();

      for (var message in _messages) {
        if (message.receiverId == currentUserId && !message.isRead) {
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
  }
  
  // Send text message
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
    String? mediaUrl,
    MessageType messageType = MessageType.text,
    int audioDuration = 0,
  }) async {
    try {
      String chatId = ChatIdHelper.generateChatId(senderId, receiverId);
      if (chatId.isEmpty) {
        print("Error: chatId is empty");
        return;
      }
      await createChatIfNotExists(senderId, receiverId);
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
          deletedFor: [],
          isDeletedForEveryone: false,
          audioDuration: audioDuration,
          isPlayed: false,
          isUploading: false);
          
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(newMessage.toMap());
          
      // Update chat list with last message details
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageType': messageType.name,
        'lastMessageTime': Timestamp.now(),
        'seenBy': [senderId, receiverId],
      });
      
      notifyListeners();
    } catch (e) {
      print("Error sending message: $e");
    }
  }
  
  // Send image message
  Future<void> sendImageMessage(
      String senderId, String receiverId, String imagePath) async {
    try {
      File imageFile = File(imagePath);
      String chatId = ChatIdHelper.generateChatId(senderId, receiverId);
      String messageId = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc()
          .id;

      //temporary message model with local image path
      MessageModel tempMessage = MessageModel(
        messageId: messageId,
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        messageType: MessageType.image,
        messageContent: "📷 Photo",
        mediaUrl: imagePath, 
        timestamp: DateTime.now(),
        isRead: false,
        isDelivered: false,
        seenBy: [],
        deletedFor: [],
        isDeletedForEveryone: false,
        audioDuration: 0,
        isPlayed: false,
        isUploading: true, 
      );

      //Add to local message list to show immediately
      _messages.add(tempMessage);
      notifyListeners();

      await createChatIfNotExists(senderId, receiverId);

      //Write the temp message to Firestore
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(tempMessage.toMap());

      //Upload image to Firebase Storage
      String fileName = "images/${DateTime.now().millisecondsSinceEpoch}.jpg";
      UploadTask uploadTask = _storage.ref(fileName).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      //Update the same Firestore message with the actual download URL
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
        "mediaUrl": downloadUrl,
        "isUploading": false,
      });

      //update chatlist
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': "📷 Photo",
        'lastMessageType': MessageType.image.name,
        'lastMessageTime': Timestamp.now(),
        'seenBy': [senderId, receiverId],
      });
    } catch (e) {
      print("Error sending image: $e");
    }
  }
  
  // Voice message methods
  Future<void> sendVoiceMessage(
      String senderId, String receiverId, String path) async {
    try {
      final file = File(path);
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.m4a";

      final ref = _storage
          .ref()
          .child('voice_messages')
          .child(senderId)
          .child(fileName);

      final metadata = SettableMetadata(contentType: 'audio/m4a');
      final uploadTask = await ref.putFile(file, metadata);
      final audioUrl = await uploadTask.ref.getDownloadURL();

      final audioDuration = await _getAudioDuration(file); // Get duration

      // Send as audio message
      await sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        text: "🎤 Voice message",
        mediaUrl: audioUrl,
        messageType: MessageType.audio,
        audioDuration: audioDuration,
      );

      print("Voice message sent: $audioUrl, duration: $audioDuration sec");
    } catch (e) {
      print("Error sending voice message: $e");
    }
  }

  Future<int> _getAudioDuration(File file) async {
    final player = AudioPlayer();
    try {
      await player.setFilePath(file.path);
      await Future.delayed(Duration(milliseconds: 500)); // allow loading
      final duration = player.duration;
      return duration?.inSeconds ?? 0;
    } catch (e) {
      print("Failed to get duration: $e");
      return 0;
    } finally {
      await player.dispose();
    }
  }

  Future<void> startRecording() async {
    try {
      isRecording = true;
      isCancelled = false;
      recordDuration = 0;
      notifyListeners();

      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          "${dir.path}/recorded_${DateTime.now().millisecondsSinceEpoch}.m4a";

      _recorder = FlutterSoundRecorder();
      await _recorder!.openRecorder();
      await _recorder!.startRecorder(toFile: filePath, codec: Codec.aacMP4);

      recordedFilePath = filePath;

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        recordDuration++;
        notifyListeners();
      });
    } catch (e) {
      print("Error starting recorder: $e");
    }
  }

  Future<void> stopRecordingAndSend(String senderId, String receiverId) async {
    try {
      _timer?.cancel();
      await _recorder?.closeRecorder();
      isRecording = false;
      notifyListeners();

      if (!isCancelled && recordedFilePath != null) {
        await sendVoiceMessage(senderId, receiverId, recordedFilePath!);
      }

      recordedFilePath = null;
      recordDuration = 0;
    } catch (e) {
      print("Error stopping recorder: $e");
    }
  }

  Future<void> cancelRecording() async {
    try {
      isCancelled = true;
      _timer?.cancel();
      await _recorder?.stopRecorder();
      await _recorder?.closeRecorder();
      recordedFilePath = null;
      isRecording = false;
      notifyListeners();
    } catch (e) {
      print("Error canceling recorder: $e");
    }
  }
  
  // Delete messages
  Future<void> deleteMessagesForMe(
    List<String> messageIds,
    String chatId,
  ) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      for (String messageId in messageIds) {
        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc(messageId)
            .update({
          'deletedFor': FieldValue.arrayUnion([currentUserId])
        });
      }

      // Check if the deleted message was the last message
      DocumentSnapshot chatDoc =
          await _firestore.collection('chats').doc(chatId).get();

      if (chatDoc.exists) {
        var data = chatDoc.data() as Map<String, dynamic>;

        // Fetch the last visible (non-deleted) message for this user
        QuerySnapshot newLastMessagesSnapshot = await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .get();

        MessageModel? newLastMessage;

        for (var doc in newLastMessagesSnapshot.docs) {
          var messageData = doc.data() as Map<String, dynamic>;

          List<dynamic> deletedFor = messageData['deletedFor'] ?? [];
          if (!deletedFor.contains(currentUserId)) {
            newLastMessage = MessageModel.fromMap(doc.id, messageData);
            break;
          }
        }

        if (newLastMessage != null) {
          await _firestore.collection('chats').doc(chatId).update({
            'lastMessage': newLastMessage.messageContent,
            'lastMessageType': newLastMessage.messageType.name,
            'lastMessageTime': Timestamp.fromDate(newLastMessage.timestamp),
            'seenBy': [currentUserId], // or update accordingly
          });
        } else {
          // If no visible messages remain, you can clear lastMessage
          await _firestore.collection('chats').doc(chatId).update({
            'lastMessage': '',
            'lastMessageType': 'text',
            'lastMessageTime': null,
            'seenBy': [],
          });
        }
      }

      _messages.removeWhere((msg) => messageIds.contains(msg.messageId));
      notifyListeners();
    } catch (e) {
      print("Error in deleteMessagesForMe: $e");
    }
  }

  Future<void> deleteMessagesForEveryone(
      List<String> messageIds, String chatId) async {
    try {
      for (String messageId in messageIds) {
        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc(messageId)
            .update({
          'isDeletedForEveryone': true,
          'mediaUrl': null // Optional: remove image if any
        });
      }
      notifyListeners();
    } catch (e) {
      print("Error in deleteMessagesForEveryone: $e");
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _recorder?.closeRecorder();
    super.dispose();
  }
}