import 'package:flutter/material.dart';
import 'package:wtsp_clone/view/screens/settings/settings_screen.dart';

class PopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == "Settings") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: "New Group", child: Text("New Group")),
        PopupMenuItem(value: "Linked device", child: Text("Linked device")),
        PopupMenuItem(value: "Payment", child: Text("Payment")),
        PopupMenuItem(
            value: "Starred messages", child: Text("Starred messages")),
        PopupMenuItem(value: "Settings", child: Text("Settings")),
      ],
    );
  }
}
