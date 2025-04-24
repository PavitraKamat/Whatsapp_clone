import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/status_provider.dart';
import 'package:wtsp_clone/fireBaseHelper/profile_image_helper.dart';
import 'package:wtsp_clone/fireBasemodel/models/profile_image_helper.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

class StatusTile extends StatelessWidget {
  final UserModel user;
  final String name;
  final String subtitle;
  final VoidCallback onTap;
  final bool isViewed;

  const StatusTile({
    Key? key,
    required this.user,
    required this.name,
    required this.subtitle,
    required this.onTap,
    required this.isViewed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StatusProvider>(context, listen: false);
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isViewed ? Colors.grey : Colors.green,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _getProfileImage(user, provider),
          ),
        ),
      ),
      title: Text(name),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  ImageProvider _getProfileImage(UserModel user, StatusProvider provider) {
    if (user.photoURL.isNotEmpty) {
      return NetworkImage(user.photoURL);
    } else {
      // Make sure ProfileImageHelper.getProfileImage returns a valid asset path
      return AssetImage(ProfileImageHelper.getProfileImage(user.phone));
    }
  }
}
