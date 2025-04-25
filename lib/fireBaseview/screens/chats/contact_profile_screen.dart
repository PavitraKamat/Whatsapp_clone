import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBaseHelper/profile_image_helper.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

class ContactProfileScreen extends StatelessWidget {
  final UserModel user;

  const ContactProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: user.photoURL.isNotEmpty
              ? Image.network(
                  user.photoURL,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color:const Color.fromARGB(255, 150, 229, 152),
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      ProfileImageHelper.getProfileImage(user.phone),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    );
                  },
                )
              : Image.asset(
                  ProfileImageHelper.getProfileImage(user.phone),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
        ),
      ),
            SizedBox(height: 10),
            Text(
              user.firstName,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              user.phone,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.call, "Audio"),
                _buildActionButton(Icons.videocam, "Video"),
                _buildActionButton(Icons.currency_rupee, "Pay"),
                _buildActionButton(Icons.search, "Search"),
              ],
            ),
            Divider(color: Colors.grey[600]),
            ListTile(
              title: Text('“Love all, trust a few, do wrong to none.”'),
              subtitle: Text('14 July 2022'),
            ),
            Divider(),
            ListTile(
              title: Text('Media, links, and docs'),
              trailing: Text('365', style: TextStyle(color: Colors.blue)),
            ),
            _mediaPreview(),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Media visibility'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Encryption'),
              subtitle: Text(
                  'Messages and calls are end-to-end encrypted. Tap to verify.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 28),
        SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.black, fontSize: 14)),
      ],
    );
  }

  Widget _mediaPreview() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _mediaItem(Icons.image),
          _mediaItem(Icons.video_collection),
          _mediaItem(Icons.video_library),
        ],
      ),
    );
  }

  Widget _mediaItem(IconData icon) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: Icon(icon, size: 40, color: Colors.grey),
    );
  }
}
