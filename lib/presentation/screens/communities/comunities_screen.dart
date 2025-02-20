import 'package:flutter/material.dart';

class CommunitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Communities",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.teal,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New Community Section
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.group_add, color: Colors.white),
            ),
            title: Text(
              "New Community",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // List of Example Communities (No Card, No Borders)
          _buildCommunityTile(
            "Tech Enthusiasts",
            "Latest updates on technology",
            "assets/tech.png",
          ),
          _buildCommunityTile(
            "Flutter Devs",
            "Community for Flutter developers",
            "assets/flutter.png",
          ),
          _buildCommunityTile(
            "Travel Lovers",
            "Explore new places & cultures",
            "assets/travel.png",
          ),
        ],
      ),

      // Floating Action Button for adding a new community
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Function to create a community list tile
  Widget _buildCommunityTile(String title, String subtitle, String imagePath) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(imagePath)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
