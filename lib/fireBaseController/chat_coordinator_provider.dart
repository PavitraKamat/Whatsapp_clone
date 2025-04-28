// Chat Coordinator - Coordinates between the different providers
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBaseController/chat_ui_provider.dart';
import 'package:wtsp_clone/fireBaseController/message_provider.dart';
import 'package:wtsp_clone/fireBaseController/user_status_provider.dart';
import 'package:wtsp_clone/fireBaseHelper/chat_id_helper.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

class ChatCoordinator extends ChangeNotifier {
  final MessageProvider messageProvider;
  final UserStatusProvider userStatusProvider;
  final ChatUIProvider chatUIProvider;
  final UserModel receiver;
  String? _chatId;
  
  ChatCoordinator({
    required this.messageProvider,
    required this.userStatusProvider,
    required this.chatUIProvider,
    required this.receiver,
  }) {
    _initialize();
  }
  
  void _initialize() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _chatId = ChatIdHelper.generateChatId(currentUserId, receiver.uid);
    
    // Initialize chat
    await messageProvider.createChatIfNotExists(currentUserId, receiver.uid);
    
    // Load messages
    await messageProvider.loadMessages(_chatId!, currentUserId);
    
    // Monitor typing status
    userStatusProvider.listenToTypingStatus(_chatId!, receiver.uid);
    
    // Update user status
    await userStatusProvider.updateLastSeen(currentUserId, isOnline: true);
    await userStatusProvider.updateReceiverLastSeen(receiver.uid);
    
    // Add listeners for scroll
    messageProvider.addListener(_onMessagesUpdated);
  }
  
  void _onMessagesUpdated() {
    // Scroll to bottom when new messages arrive
    chatUIProvider.scrollToBottom();
  }
  
  // Send a message
  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await messageProvider.sendMessage(
      senderId: currentUserId,
      receiverId: receiver.uid,
      text: text,
    );
    
    // Reset typing status
    userStatusProvider.resetTyping();
    
    // Update last seen
    await userStatusProvider.updateLastSeen(currentUserId, isOnline: true);
  }
  
  // Send image
  Future<void> sendImage(String imagePath) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await messageProvider.sendImageMessage(
      currentUserId, 
      receiver.uid, 
      imagePath
    );
  }
  
  // Voice message methods
  Future<void> startRecording() async {
    await messageProvider.startRecording();
  }
  
  Future<void> stopRecordingAndSend() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    await messageProvider.stopRecordingAndSend(
      currentUserId, 
      receiver.uid
    );
  }
  
  Future<void> cancelRecording() async {
    await messageProvider.cancelRecording();
  }
  
  // Delete messages
  Future<void> deleteMessagesForMe() async {
    if (_chatId == null || chatUIProvider.selectedMessageIds.isEmpty) return;
    
    await messageProvider.deleteMessagesForMe(
      chatUIProvider.selectedMessageIds,
      _chatId!
    );
    
    chatUIProvider.clearSelection();
  }
  
  Future<void> deleteMessagesForEveryone() async {
    if (_chatId == null || chatUIProvider.selectedMessageIds.isEmpty) return;
    
    await messageProvider.deleteMessagesForEveryone(
      chatUIProvider.selectedMessageIds,
      _chatId!
    );
    
    chatUIProvider.clearSelection();
  }
  
  @override
  void dispose() {
    messageProvider.removeListener(_onMessagesUpdated);
    super.dispose();
  }
}