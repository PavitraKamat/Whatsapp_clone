import 'package:flutter/material.dart';

class StatusTile extends StatelessWidget {
  final String imagePath;
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  const StatusTile({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
