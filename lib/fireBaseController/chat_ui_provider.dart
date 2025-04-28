// Chat UI Provider - Handles UI-related operations and state
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

class ChatUIProvider extends ChangeNotifier {
  final UserModel user;
  ScrollController scrollController = ScrollController();
  bool _isActive = true;
  bool _isSelectionMode = false;
  final List<String> _selectedMessageIds = [];
  Offset _initialDragOffset = Offset.zero;
  
  bool get isSelectionMode => _isSelectionMode;
  List<String> get selectedMessageIds => _selectedMessageIds;
  Offset get initialDragOffset => _initialDragOffset;
  
  ChatUIProvider({required this.user});
  
  // Scroll to bottom of chat
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
  
  // Message selection methods
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
  
  // Message drag gesture
  void setInitialDragOffset(Offset offset) {
    _initialDragOffset = offset;
  }

  void resetInitialDragOffset() {
    _initialDragOffset = Offset.zero;
  }
  
  @override
  void dispose() {
    _isActive = false;
    scrollController.dispose();
    super.dispose();
  }
}