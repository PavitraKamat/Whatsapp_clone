import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBaseHelper/profile_image_helper.dart';

class UserProfileHelper extends StatelessWidget {
  final String photoUrl;
  final String phone;

  const UserProfileHelper( {super.key,required this.photoUrl,required this.phone});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: photoUrl.isNotEmpty
            ? Image.network(
                photoUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: const Color.fromARGB(255, 150, 229, 152),
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    ProfileImageHelper.getProfileImage(phone),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.asset(
                ProfileImageHelper.getProfileImage(phone),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
