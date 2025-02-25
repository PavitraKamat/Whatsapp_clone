import 'package:flutter/material.dart';

class Status {
  final String text;
  final Color backgroundColor;
  final DateTime timestamp;

  Status(
      {required this.text,
      required this.backgroundColor,
      required this.timestamp});
}
