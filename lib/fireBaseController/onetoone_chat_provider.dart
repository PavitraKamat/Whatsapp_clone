import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
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
  bool isRecording = false;
  bool isCancelled = false;
  int recordDuration = 0;
  FlutterSoundRecorder? _recorder;
  String? recordedFilePath;
  Timer? _timer;

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
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      _messages = snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
          .where((message) => !(message.deletedFor.contains(currentUserId)))
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
    int audioDuration = 0,
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
          deletedFor: [],
          isDeletedForEveryone: false,
          audioDuration: audioDuration,
          //audioDuration: 0,
          isPlayed: false);
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
        'seenBy': [senderId,receiverId],
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

  Future<void> sendVoiceMessage(
      String senderId, String receiverId, String path) async {
    if (!_isActive) return;

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

      // Optionally update last seen
      await updateLastSeen(senderId, isOnline: true);

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
      final path = await _recorder?.stopRecorder();
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
        String? lastMessage = data['lastMessage'];
        Timestamp? lastMessageTime = data['lastMessageTime'];

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
      clearSelection();
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
          //'messageContent': '', // Optional: clear message
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
    _isActive = false;
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
