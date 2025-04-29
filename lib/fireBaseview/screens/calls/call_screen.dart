import 'package:flutter/material.dart';

class FireBaseCallsScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<FireBaseCallsScreen> {
  final List<Map<String, dynamic>> callHistory = [
    {
      "name": "John Doe",
      "time": "Today, 10:30 AM",
      "isVideo": false,
      "incoming": true
    },
    {
      "name": "Alice",
      "time": "Yesterday, 5:45 PM",
      "isVideo": true,
      "incoming": false
    },
    {
      "name": "Mike",
      "time": "Yesterday, 2:15 PM",
      "isVideo": false,
      "incoming": true
    },
    {
      "name": "Emma",
      "time": "Monday, 9:00 AM",
      "isVideo": true,
      "incoming": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Calls",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color.fromARGB(255, 108, 193, 149),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
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
      body: callHistory.isEmpty
          ? Center(
              child: Text(
                "No recent calls",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: callHistory.length,
              itemBuilder: (context, index) {
                final call = callHistory[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(call["name"],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(call["time"]),
                  trailing: Icon(
                    call["isVideo"] ? Icons.videocam : Icons.call,
                    color: call["incoming"] ? Colors.red : Colors.green,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 108, 193, 149),
        child: Icon(Icons.add_call,color: Colors.white,),
        onPressed: () {},
      ),
    );
  }
}
