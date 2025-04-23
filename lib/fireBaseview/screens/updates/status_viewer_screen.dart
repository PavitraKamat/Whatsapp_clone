import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/status_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/status_model.dart';
import 'package:wtsp_clone/fireBaseview/components/profileAvatar.dart';

class StatusViewerScreen extends StatefulWidget {
  final List<StatusModel> statuses;
  final int initialIndex;

  const StatusViewerScreen({
    Key? key,
    required this.statuses,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _StatusViewerScreenState createState() => _StatusViewerScreenState();
}

class _StatusViewerScreenState extends State<StatusViewerScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _progressController;
  bool _isPaused = false;
  bool _isImageLoading = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStatus();
      }
    });

    _startProgress();
  }

  void _startProgress() {
    _progressController.forward(from: 0.0);
  }

  void _pauseProgress() {
    if (!_isPaused) {
      _progressController.stop();
      _isPaused = true;
    }
  }

  void _resumeProgress() {
    if (_isPaused) {
      _progressController.forward();
      _isPaused = false;
    }
  }

  void _nextStatus() {
    if (_currentIndex < widget.statuses.length - 1) {
      setState(() {
        _currentIndex++;
        _isImageLoading = true;
      });
      _pauseProgress();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStatus() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isImageLoading = true;
      });
      _pauseProgress();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.statuses[_currentIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final statusProvider = Provider.of<StatusProvider>(context);
    final user = statusProvider.getUser(status.userId);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (_) => _pauseProgress(),
        onTapUp: (_) => _resumeProgress(),
        onTapCancel: () => _resumeProgress(),
        onLongPress: () => _pauseProgress(),
        onLongPressUp: () => _resumeProgress(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildStatusContent(status),
            Row(
              children: [
                GestureDetector(
                  onTap: _previousStatus,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    width: screenWidth * 0.3,
                    color: Colors.transparent,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                GestureDetector(
                  onTap: _nextStatus,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    width: screenWidth * 0.3,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: List.generate(widget.statuses.length, (index) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return Stack(
                                children: [
                                  // Background bar
                                  Container(
                                    height: 2.5,
                                    width: constraints.maxWidth,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),

                                  // Progress bar
                                  Container(
                                    height: 2.5,
                                    width: index < _currentIndex
                                        ? constraints.maxWidth
                                        : index == _currentIndex
                                            ? constraints.maxWidth *
                                                _progressController.value
                                            : 0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 10),
                        if (user != null)
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: ProfileAvataar(
                              user: user,
                              onSelectImage: () {
                                if (status.userId ==
                                    FirebaseAuth.instance.currentUser?.uid) {
                                  statusProvider.selectImage();
                                }
                              },
                              hasStatus: true,
                            ),
                          ),

                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                status.username,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                timeAgo(status.timestamp!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),

                        PopupMenuButton<String>(
                          icon:
                              const Icon(Icons.more_vert, color: Colors.white),
                          onSelected: (value) {
                            // Handle menu options
                            if (value == 'mute') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Status muted')));
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'mute',
                              child: Text('Mute'),
                            ),
                            const PopupMenuItem(
                              value: 'report',
                              child: Text('Report'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 8, bottom: 16, top: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      // Colors.black.withOpacity(0.8),
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            // color: Colors.white.withOpacity(0.15),
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Colors.white24, width: 0.5),
                          ),
                          child: const Text(
                            'Reply',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A884), // WhatsApp green
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusContent(StatusModel status) {
    switch (status.statusType) {
      case StatusType.image:
      final image = Image.network(status.mediaUrl ?? '', fit: BoxFit.contain);
      
    image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener(
      (info, _) {
        if (_isImageLoading) {
          setState(() {
            _isImageLoading = false;
          });
          _resumeProgress();
        }
      },
      onError: (error, stackTrace) {
        setState(() {
          _isImageLoading = false;
        });
        _resumeProgress();
      },
    ),
  );
  return Stack(
    fit: StackFit.expand,
    children: [
      Center(child: image),
      if (_isImageLoading)
        const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
    ],
  );
      case StatusType.text:
        return Container(
          decoration: BoxDecoration(
            color: status.color != null
                ? _parseColor(status.color!)
                : const Color(0xFF075E54), // WhatsApp default green
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
          alignment: Alignment.center,
          child: Text(
            status.textContent ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        );
    }
  }
}

String timeAgo(DateTime timestamp) {
  final now = DateTime.now();
  final diff = now.difference(timestamp);
  if (diff.inMinutes < 60) return "${diff.inMinutes} minutes ago";
  if (diff.inHours < 24) return "${diff.inHours} hours ago";
  return "${diff.inDays} days ago";
}

Color _parseColor(String colorStr) {
  try {
    if (colorStr.startsWith('#')) {
      String hexColor = colorStr.replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF" + hexColor; 
      }
      return Color(int.parse("0x$hexColor"));
    } else if (colorStr.startsWith('Color(')) {
      // Extract the color value from the string "Color(0xFFFFFFFF)"
      final valueStr =
          colorStr.substring(colorStr.indexOf('(') + 1, colorStr.indexOf(')'));
      return Color(int.parse(valueStr));
    } else {
      // Handle known color names
      switch (colorStr.toLowerCase()) {
        case 'green':
          return const Color(0xFF075E54);
        case 'blue':
          return const Color(0xFF128C7E);
        case 'red':
          return const Color(0xFFC70039);
        case 'orange':
          return const Color(0xFFFF8C00);
        case 'purple':
          return const Color(0xFF8A2BE2);
        default:
          return const Color(0xFF075E54); 
      }
    }
  } catch (e) {
    return const Color(0xFF075E54); 
  }
}



      // case StatusType.video:
      //   // Video placeholder - in a real app, use a video player
      //   return Stack(
      //     fit: StackFit.expand,
      //     children: [
      //       status.mediaUrl != null && status.mediaUrl!.isNotEmpty
      //           ? Image.network(
      //               status.mediaUrl!,
      //               fit: BoxFit.cover,
      //               errorBuilder: (context, error, stackTrace) => Container(
      //                 color: Colors.black,
      //                 child: const Center(
      //                   child: Icon(Icons.video_file, color: Colors.white54, size: 64),
      //                 ),
      //               ),
      //             )
      //           : Container(
      //               color: Colors.black,
      //               child: const Center(
      //                 child: Icon(Icons.video_file, color: Colors.white54, size: 64),
      //               ),
      //             ),
      //     ],
      //   );