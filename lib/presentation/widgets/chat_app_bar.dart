import 'package:flutter/material.dart';
import 'package:wtsp_clone/data/models/contact_model.dart';
import 'package:wtsp_clone/data/models/profile_image_helper.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ContactModel contact;

  ChatAppBar({Key? key, required this.contact}) : super(key: key);

  final List<String> profileImages = [
    "assets/images/profile.jpg",
    "assets/images/profile1.jpg",
    "assets/images/profile2.jpg",
    "assets/images/profile3.jpg",
    "assets/images/profile4.jpg",
  ];

  // String getRandomImage() {
  //   final random = Random();
  //   return profileImages[random.nextInt(profileImages.length)];
  // }

  String getProfileImage(String identifier) {
    int index = getConsistentIndex(identifier);
    return profileImages[index];
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 80,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back, size: 24, color: Colors.black),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueGrey,
              backgroundImage:
                  AssetImage(getProfileImage(contact.phone ?? contact.name)),
            ),
          ],
        ),
      ),
      title: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.name,
              style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
            ),
            Text(contact.lastSeen, style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
        IconButton(onPressed: () {}, icon: Icon(Icons.call)),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) => print(value),
          itemBuilder: (context) => [
            PopupMenuItem(child: Text("Search"), value: "Search"),
            PopupMenuItem(child: Text("Add to List"), value: "Add to List"),
            PopupMenuItem(
                child: Text("Media, Links, and Docs"), value: "Media"),
          ],
        ),
      ],
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
