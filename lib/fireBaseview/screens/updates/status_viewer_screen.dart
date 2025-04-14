import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBasemodel/models/status_model.dart';

class StatusViewerScreen extends StatefulWidget {
  final List<StatusModel> statuses;

  const StatusViewerScreen({Key? key, required this.statuses}) : super(key: key);

  @override
  _StatusViewerScreenState createState() => _StatusViewerScreenState();
}

class _StatusViewerScreenState extends State<StatusViewerScreen> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _nextStatus();
    });
  }

  void _nextStatus() {
    if (_currentIndex < widget.statuses.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _timer.cancel();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.statuses[_currentIndex];

    return GestureDetector(
      onTap: _nextStatus,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Media or Text Display
            Center(
              child: status.statusType == StatusType.image
                  ? Image.network(
                      status.mediaUrl ?? "",
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.white, size: 100),
                    )
                  : Container(
                      color: Colors.blueGrey,
                      alignment: Alignment.center,
                      child: Text(
                        status.textContent ?? "",
                        style: const TextStyle(color: Colors.white, fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),

            // Progress Indicator
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                children: List.generate(widget.statuses.length, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 3,
                      decoration: BoxDecoration(
                        color: index < _currentIndex
                            ? Colors.white
                            : index == _currentIndex
                                ? Colors.white.withOpacity(0.8)
                                : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Username and Back Button
            Positioned(
              top: 40,
              left: 20,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    status.username,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:provider/provider.dart';
// import 'package:wtsp_clone/fireBaseController/status_provider.dart';
// import 'package:wtsp_clone/fireBasemodel/models/status_model.dart';

// class StatusViewerScreen extends StatefulWidget {
//   final List<StatusModel> statuses;
//   final Function(String)? onStatusViewed;
  
//   const StatusViewerScreen({
//     Key? key, 
//     required this.statuses,
//     this.onStatusViewed,
//   }) : super(key: key);

//   @override
//   _StatusViewerScreenState createState() => _StatusViewerScreenState();
// }

// class _StatusViewerScreenState extends State<StatusViewerScreen> with SingleTickerProviderStateMixin {
//   int _currentIndex = 0;
//   late Timer _timer;
//   late AnimationController _progressController;
//   final int _statusDuration = 5; // Duration in seconds for each status

//   @override
//   void initState() {
//     super.initState();
    
//     // Initialize progress animation controller
//     _progressController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: _statusDuration),
//     )..addListener(() {
//       setState(() {}); // Rebuild for progress indicator
//     });

//     _startTimer();
//     _progressController.forward();
    
//     // Mark current status as viewed
//     _markAsViewed();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: _statusDuration), (timer) {
//       if (_currentIndex < widget.statuses.length - 1) {
//         setState(() {
//           _currentIndex++;
//           _progressController.reset();
//           _progressController.forward();
//           _markAsViewed();
//         });
//       } else {
//         timer.cancel();
//         Navigator.pop(context);
//       }
//     });
//   }
  
//   void _markAsViewed() {
//     final currentStatus = widget.statuses[_currentIndex];
//     if (widget.onStatusViewed != null) {
//       widget.onStatusViewed!(currentStatus.statusId);
//     }
//   }

//   void _onTapScreen(TapPosition position) {
//     if (position == TapPosition.left && _currentIndex > 0) {
//       // Go to previous status
//       setState(() {
//         _currentIndex--;
//         _progressController.reset();
//         _progressController.forward();
//         _markAsViewed();
//       });
//     } else if (position == TapPosition.right && _currentIndex < widget.statuses.length - 1) {
//       // Go to next status
//       setState(() {
//         _currentIndex++;
//         _progressController.reset();
//         _progressController.forward();
//         _markAsViewed();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _progressController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentStatus = widget.statuses[_currentIndex];
//     final statusProvider = Provider.of<StatusProvider>(context, listen: false);
    
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Status progress indicators
//             Positioned(
//               top: 10,
//               left: 10,
//               right: 10,
//               child: Row(
//                 children: List.generate(
//                   widget.statuses.length,
//                   (index) => Expanded(
//                     child: Container(
//                       height: 2,
//                       margin: EdgeInsets.symmetric(horizontal: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                       child: index == _currentIndex
//                           ? LinearProgressIndicator(
//                               value: _progressController.value,
//                               backgroundColor: Colors.grey.withOpacity(0.5),
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             )
//                           : Container(
//                               color: index < _currentIndex
//                                   ? Colors.white
//                                   : Colors.transparent,
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // User info
//             Positioned(
//               top: 20,
//               left: 10,
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 20,
//                     backgroundImage: NetworkImage(
//                       currentStatus.userId == FirebaseAuth.instance.currentUser?.uid
//                           ? (FirebaseAuth.instance.currentUser?.photoURL ?? 'https://via.placeholder.com/150')
//                           : 'https://via.placeholder.com/150' // Replace with actual user photo logic
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     currentStatus.username,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   if (currentStatus.timestamp != null)
//                     Text(
//                       _getTimeAgo(currentStatus.timestamp!),
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 12,
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             // Close button
//             Positioned(
//               top: 20,
//               right: 10,
//               child: IconButton(
//                 icon: Icon(Icons.close, color: Colors.white),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),

//             // Status content
//             Center(
//               child: GestureDetector(
//                 onTapDown: (details) {
//                   final screenWidth = MediaQuery.of(context).size.width;
//                   if (details.globalPosition.dx < screenWidth / 2) {
//                     _onTapScreen(TapPosition.left);
//                   } else {
//                     _onTapScreen(TapPosition.right);
//                   }
//                 },
//                 child: _buildStatusContent(currentStatus),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusContent(StatusModel status) {
//     switch (status.statusType) {
//       case StatusType.image:
//         return status.mediaUrl != null
//             ? Image.network(
//                 status.mediaUrl!,
//                 fit: BoxFit.contain,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                               loadingProgress.expectedTotalBytes!
//                           : null,
//                     ),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Center(
//                     child: Icon(Icons.error, color: Colors.white),
//                   );
//                 },
//               )
//             : Center(child: Text("Image not available", style: TextStyle(color: Colors.white)));
      
//       case StatusType.text:
//         return Container(
//           margin: EdgeInsets.all(16),
//           padding: EdgeInsets.all(20),
//           width: double.infinity,
//           color: status.color != null
//               ? Color(int.parse(status.color!.replaceAll('#', '0xFF')))
//               : Colors.blue,
//           alignment: Alignment.center,
//           child: Text(
//             status.textContent ?? "No text content",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//     }
//   }

//   String _getTimeAgo(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);
    
//     if (difference.inSeconds < 60) {
//       return "Just now";
//     } else if (difference.inMinutes < 60) {
//       return "${difference.inMinutes}m ago";
//     } else if (difference.inHours < 24) {
//       return "${difference.inHours}h ago";
//     } else {
//       return "${difference.inDays}d ago";
//     }
//   }
// }

// enum TapPosition { left, right }
