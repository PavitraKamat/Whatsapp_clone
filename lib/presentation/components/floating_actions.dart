import 'package:flutter/material.dart';

class FloatingActions extends StatelessWidget {
  final VoidCallback onTextStatus;
  final VoidCallback onImageStatus;

  const FloatingActions({
    Key? key,
    required this.onTextStatus,
    required this.onImageStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "textStatus",
          onPressed: onTextStatus,
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.edit, color: Colors.white),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "imageStatus",
          onPressed: onImageStatus,
          backgroundColor: Colors.teal,
          child: const Icon(Icons.camera_alt, color: Colors.white),
        ),
      ],
    );
  }
}
