// import 'package:flutter/material.dart';

// class MessageSelectionController extends ChangeNotifier {
//   bool _isSelectionMode = false;
//   List<String> _selectedMessageIds = [];
  
//   bool get isSelectionMode => _isSelectionMode;
//   List<String> get selectedMessageIds => _selectedMessageIds;
  
//   void toggleSelectionMode(bool value) {
//     _isSelectionMode = value;
//     if (!value) _selectedMessageIds.clear();
//     notifyListeners(); 
//   }
  
//   void toggleMessageSelection(String messageId) {
//     if (_selectedMessageIds.contains(messageId)) {
//       _selectedMessageIds.remove(messageId);
//     } else {
//       _selectedMessageIds.add(messageId);
//     }
    
//     if (_selectedMessageIds.isEmpty) {
//       _isSelectionMode = false;
//     }
    
//     notifyListeners();
//   }
  
//   void clearSelection() {
//     _selectedMessageIds.clear();
//     _isSelectionMode = false;
//     notifyListeners();
//   }
// }