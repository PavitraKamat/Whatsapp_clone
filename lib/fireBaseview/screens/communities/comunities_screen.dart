// import 'package:flutter/material.dart';

// class FireBaseCommunitiesScreen extends StatelessWidget {
//   const FireBaseCommunitiesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Colors.white,
//       appBar: communityAppBar(),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.green,
//               child: Icon(Icons.group_add, color: Colors.white),
//             ),
//             title: Text(
//               "New Community",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           _buildCommunityTile(
//             "Tech Enthusiasts",
//             "Latest updates on technology",
//             "assets/images/channel1.png",
//           ),
//           _buildCommunityTile(
//             "Flutter Devs",
//             "Community for Flutter developers",
//             "assets/images/flutter.png",
//           ),
//           _buildCommunityTile(
//             "Travel Lovers",
//             "Explore new places & cultures",
//             "assets/images/travel.jpeg",
//           ),
//         ],
//       ),

//       // Floating Action Button for adding a new community
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: Color.fromARGB(255, 108, 193, 149),
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }

//   AppBar communityAppBar() {
//     return AppBar(
//       title: Text(
//         "Communities",
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 22,
//           color: Color.fromARGB(255, 108, 193, 149),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       actions: [
//         IconButton(
//           icon: Icon(Icons.search, color: Colors.black),
//           onPressed: () {},
//         ),
//         PopupMenuButton<String>(
//           icon: Icon(Icons.more_vert, color: Colors.black),
//           itemBuilder: (BuildContext context) {
//             return [
//               PopupMenuItem<String>(
//                 value: "Settings",
//                 child: Text("Settings"),
//               ),
//             ];
//           },
//         ),
//       ],
//     );
//   }

//   // Function to create a community list tile
//   Widget _buildCommunityTile(String title, String subtitle, String imagePath) {
//     return ListTile(
//       leading: CircleAvatar(backgroundImage: AssetImage(imagePath)),
//       title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//       subtitle: Text(subtitle),
//     );
//   }
// }

import 'package:flutter/material.dart';

class FireBaseCommunitiesScreen extends StatelessWidget {
  const FireBaseCommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        children: [
          _buildNewCommunityTile(),
          const SizedBox(height: 12),
          _buildCommunityCard(
            title: "Tech Enthusiasts",
            subtitle: "Latest updates on technology",
            imagePath: "assets/images/channel1.png",
          ),
          _buildCommunityCard(
            title: "Flutter Devs",
            subtitle: "Community for Flutter developers",
            imagePath: "assets/images/flutter.png",
          ),
          _buildCommunityCard(
            title: "Travel Lovers",
            subtitle: "Explore new places & cultures",
            imagePath: "assets/images/travel.jpeg",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 108, 193, 149),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Communities",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Color.fromARGB(255, 108, 193, 149),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: "Settings",
              child: Text("Settings"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewCommunityTile() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 108, 193, 149),
          child: Icon(Icons.group_add, color: Colors.white),
        ),
        title: const Text(
          "New Community",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          // Handle new community creation
        },
      ),
    );
  }

  Widget _buildCommunityCard({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        onTap: () {
          // Handle community tap
        },
      ),
    );
  }
  
}

