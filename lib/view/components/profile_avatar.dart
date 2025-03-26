import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/model/models/profile_image_helper.dart';

class ProfileAvatar extends StatelessWidget {
  //final Uint8List? image;
  final String? image;
  final double radius;
  final VoidCallback? onTap;

  const ProfileAvatar({
    Key? key,
    required this.image,
    required this.radius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          //backgroundImage: image != null ? NetworkImage(image!) : null,
          backgroundImage: provider.imageUrl != null &&
                  provider.imageUrl!.isNotEmpty
              ? NetworkImage(provider.imageUrl!) as ImageProvider
              : AssetImage(ProfileImageHelper.getProfileImage(provider.phoneNumber)),
          child: image == null ? Icon(Icons.person, size: radius) : null,
        ),
        if (onTap != null)
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: onTap,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.teal,
                child: Icon(Icons.add_a_photo, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
