import 'package:flutter/material.dart';

class StatusViewScreen extends StatelessWidget {
  final String status;

  StatusViewScreen({required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // WhatsApp-style background
      body: Center(
        child: Text(
          status,
          style: TextStyle(color: Colors.white, fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
