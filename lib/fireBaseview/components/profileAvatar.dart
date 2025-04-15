import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/profile_image_helper.dart';

class ProfileAvataar extends StatelessWidget {
  final VoidCallback onSelectImage;
  final bool hasStatus;

  const ProfileAvataar({
    Key? key,
    required this.onSelectImage,
    required this.hasStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final provider = Provider.of<ProfileProvider>(context);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: hasStatus ? Colors.green : Colors.grey,
              width: 3,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade300,
              child: ClipOval(
                child: SizedBox(
                  width: 24 * 2,
                  height: 24 * 2,
                  child: currentUser?.photoURL != null
                      ? Image.network(
                          currentUser!.photoURL!,
                          fit: BoxFit.cover,
                          width: 24 * 2,
                          height: 24 * 2,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.teal),
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                          ProfileImageHelper.getProfileImage(
                              provider.phoneNumber),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                ),
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
