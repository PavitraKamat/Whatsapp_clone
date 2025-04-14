import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/status_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/profile_image_helper.dart';

class StatusTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  const StatusTile({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StatusProvider>(context,listen: false);
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: imageUrl.isNotEmpty
            ? NetworkImage(imageUrl)
            : AssetImage(ProfileImageHelper.getProfileImage(provider.userId))
                as ImageProvider,
      ),
      title: Text(name),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
