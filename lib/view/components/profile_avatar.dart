import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/model/models/profile_image_helper.dart';

class ProfileAvatar extends StatelessWidget {
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
          backgroundColor: Colors.grey[300],
          child: ClipOval(
            child: SizedBox(
              width: radius * 2,
              height: radius * 2,
              child: provider.imageUrl != null && provider.imageUrl!.isNotEmpty
                  ? Image.network(
                      provider.imageUrl!,
                      fit: BoxFit.cover,
                      width: radius * 2,
                      height: radius * 2,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.teal),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          ProfileImageHelper.getProfileImage(
                              provider.phoneNumber),
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      ProfileImageHelper.getProfileImage(provider.phoneNumber),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
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
