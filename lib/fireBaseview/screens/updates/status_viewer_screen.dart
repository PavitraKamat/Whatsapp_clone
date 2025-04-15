import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBasemodel/models/status_model.dart';

class StatusViewerScreen extends StatefulWidget {
  final List<StatusModel> statuses;

  const StatusViewerScreen({Key? key, required this.statuses})
      : super(key: key);

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
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
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
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 100),
                    )
                  : Container(
                      color: status.color != null
                          ? _parseColor(status.color!)
                          : Colors.blueGrey,
                      alignment: Alignment.center,
                      child: Text(
                        status.textContent ?? "",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 28),
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

Color _parseColor(String colorStr) {
  if (colorStr.startsWith('#')) {
    return Color(int.parse(colorStr.substring(1), radix: 16));
  } else if (colorStr.startsWith('Color(')) {
    try {
      // Extract the color value from the string "Color(0xFFFFFFFF)"
      final valueStr =
          colorStr.substring(colorStr.indexOf('(') + 1, colorStr.indexOf(')'));
      return Color(int.parse(valueStr));
    } catch (e) {
      return Colors.blueGrey; // Default fallback
    }
  }
  return Colors.blueGrey; // Default fallback
}
