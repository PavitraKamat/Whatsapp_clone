import 'package:flutter/material.dart';
import 'package:wtsp_clone/model/models/contact_model.dart';

class ContactProfileScreen extends StatelessWidget {
  final ContactModel contact;

  ContactProfileScreen({Key? key, required this.contact}) : super(key: key);

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
              radius: 50,
              backgroundColor: Colors.grey[800],
              backgroundImage: AssetImage(contact.image),
            ),
            SizedBox(height: 10),
            Text(
              contact.name,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              contact.phone,
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

  // Widget _iconButton(IconData icon, String label) {
  //   return Column(
  //     children: [
  //       IconButton(
  //         icon: Icon(icon, size: 30, color: Colors.green),
  //         onPressed: () {},
  //       ),
  //       Text(label, style: TextStyle(fontSize: 12)),
  //     ],
  //   );
  // }

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
