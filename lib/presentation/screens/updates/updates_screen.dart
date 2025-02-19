import 'package:flutter/material.dart';

class UpdatesScreen extends StatefulWidget {
  @override
  _UpdatesscreenState createState() => _UpdatesscreenState();
}

class _UpdatesscreenState extends State<StatefulWidget> {
  void _onMenuSelected(String value) {
    if (value == "Settings") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Settings Clicked")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Updates",
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "Settings",
                  child: Text("Settings"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          "No Updates",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
