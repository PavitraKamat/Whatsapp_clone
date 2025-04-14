import 'dart:async';
import 'package:flutter/material.dart';

class StatusViewerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> statuses;
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
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentIndex < widget.statuses.length - 1) {
        setState(() => _currentIndex++);
      } else {
        timer.cancel();
        Navigator.pop(context);
      }
    });
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
      onTap: () {
        if (_currentIndex < widget.statuses.length - 1) {
          setState(() => _currentIndex++);
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: status['type'] == 'image'
              ? Image.memory(status['content'])
              : Container(
                  color: status['color'],
                  alignment: Alignment.center,
                  child: Text(
                    status['content'],
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
    );
  }
}

