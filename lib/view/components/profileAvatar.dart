import 'dart:typed_data';
import 'package:flutter/material.dart';

class ProfileAvataar extends StatelessWidget {
  final Uint8List? image;
  final VoidCallback onSelectImage;
  final bool hasStatus;

  const ProfileAvataar({
    Key? key,
    required this.image,
    required this.onSelectImage,
    required this.hasStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                hasStatus ? Border.all(color: Colors.green, width: 3) : null,
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: image != null
                ? MemoryImage(image!)
                : const AssetImage("assets/images/profile.jpg")
                    as ImageProvider,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onSelectImage,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
