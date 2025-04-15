import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/status_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/profile_image_helper.dart';

class StatusTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String subtitle;
  final VoidCallback onTap;
  final bool isViewed;

  const StatusTile({
    Key? key,
    required this.imageUrl,
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
            color: isViewed ? Colors.grey : Colors.teal,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _getProfileImage(imageUrl, provider),
          ),
        ),
      ),
      title: Text(name),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  ImageProvider _getProfileImage(String imageUrl, StatusProvider provider) {
    if (imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      // Make sure ProfileImageHelper.getProfileImage returns a valid asset path
      return AssetImage(ProfileImageHelper.getProfileImage(provider.userId ?? ""));
    }
  }
}
