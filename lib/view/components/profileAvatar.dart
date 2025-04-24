import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/profile_image_helper.dart';
import 'package:wtsp_clone/model/models/profile_image_helper.dart';

class ProfileAvataar extends StatelessWidget {
  //final String? image;
  final VoidCallback onSelectImage;
  final bool hasStatus;

  const ProfileAvataar({
    Key? key,
    //required this.image,
    required this.onSelectImage,
    required this.hasStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
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
            child: ClipOval(
            child: SizedBox(
              width: 28 * 2,
              height: 28 * 2,
              child: provider.imageUrl != null && provider.imageUrl!.isNotEmpty
                  ? Image.network(
                      provider.imageUrl!,
                      fit: BoxFit.cover,
                      width: 28 * 2,
                      height: 28 * 2,
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
                  : Icon(Icons.person, size: 28, color: Colors.grey[700]),
            ),
          ),
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
