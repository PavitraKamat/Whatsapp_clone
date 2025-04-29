// import 'package:flutter/material.dart';
// import 'package:wtsp_clone/fireBasemodel/models/status_model.dart';

// class StatusViewerProvider extends ChangeNotifier with TickerProviderStateMixin {
//   final List<StatusModel> statuses;
//   late AnimationController progressController;
//   int currentIndex;
//   bool isPaused = false;
//   bool isImageLoading = true;
//   final BuildContext context;

//   StatusViewerProvider({
//     required this.context,
//     required this.statuses,
//     required this.currentIndex,
//   }) {
//     progressController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     )..addListener(() => notifyListeners());

//     progressController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) nextStatus();
//     });

//     startProgress();
//   }

//   StatusModel get currentStatus => statuses[currentIndex];

//   void startProgress() {
//     progressController.forward(from: 0.0);
//   }

//   void pauseProgress() {
//     if (!isPaused) {
//       progressController.stop();
//       isPaused = true;
//       notifyListeners();
//     }
//   }

//   void resumeProgress() {
//     if (isPaused) {
//       progressController.forward();
//       isPaused = false;
//       notifyListeners();
//     }
//   }

//   void nextStatus() {
//     if (currentIndex < statuses.length - 1) {
//       currentIndex++;
//       isImageLoading = true;
//       notifyListeners();
//       pauseProgress();
//     } else {
//       Navigator.pop(context);
//     }
//   }

//   void previousStatus() {
//     if (currentIndex > 0) {
//       currentIndex--;
//       isImageLoading = true;
//       notifyListeners();
//       pauseProgress();
//     }
//   }

//   void setImageLoaded() {
//     isImageLoading = false;
//     resumeProgress();
//     notifyListeners();
//   }

//   void disposeController() {
//     progressController.dispose();
//     super.dispose();
//   }
// }
