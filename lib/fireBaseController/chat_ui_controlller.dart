// import 'package:flutter/material.dart';

// class ChatUIController extends ChangeNotifier {
//   final ScrollController scrollController = ScrollController();
//   final TextEditingController messageController = TextEditingController();
//   Offset _initialDragOffset = Offset.zero;
//   bool _isActive = true;

//   Offset get initialDragOffset => _initialDragOffset;

//   void setInitialDragOffset(Offset offset) {
//     _initialDragOffset = offset;
//     notifyListeners();
//   }

//   void resetInitialDragOffset() {
//     _initialDragOffset = Offset.zero;
//     notifyListeners();
//   }

//   void scrollToBottom() {
//     if (!_isActive) return;

//     if (scrollController.hasClients) {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (_isActive && scrollController.hasClients) {
//           scrollController.animateTo(
//             scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _isActive = false;
//     messageController.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }
// }