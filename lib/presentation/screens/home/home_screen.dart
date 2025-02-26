import 'package:flutter/material.dart';
import 'package:wtsp_clone/presentation/screens/calls/call_screen.dart';
//import 'package:wtsp_clone/presentation/screens/chats/chats_screen.dart';
import 'package:wtsp_clone/presentation/screens/communities/comunities_screen.dart';
import 'package:wtsp_clone/presentation/screens/contacts/contacts_screen.dart';
import 'package:wtsp_clone/presentation/screens/settings/settings_screen.dart';
import 'package:wtsp_clone/presentation/screens/updates/updates_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ContactsScreen(),
    UpdatesScreen(
        //onImageSelected: (image) {},
        //onTextStatusAdded: (text) {},
        ),
    CommunitiesScreen(),
    CallsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMenuSelected(String value) {
    if (value == "Settings") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text(
                "WhatsApp",
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              actions: [
                IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: () {},
                ),
                PopupMenuButton<String>(
                  color: Colors.white,
                  icon: Icon(Icons.more_vert),
                  onSelected: _onMenuSelected,
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text("New Group"), value: "New Group"),
                    PopupMenuItem(
                        child: Text("Linked device"), value: "Linked device"),
                    PopupMenuItem(child: Text("Payment"), value: "Payment"),
                    PopupMenuItem(
                        child: Text("Starred messages"),
                        value: "Starred messages"),
                    PopupMenuItem(child: Text("Settings"), value: "Settings"),
                  ],
                ),
              ],
            )
          : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      items: [
        _buildNavItem(Icons.chat, "Chats", 0),
        _buildNavItem(Icons.update, "Updates", 1),
        _buildNavItem(Icons.groups, "Communities", 2),
        _buildNavItem(Icons.call, "Calls", 3),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      label: label,
      icon: Stack(
        alignment: Alignment.center,
        children: [
          if (_selectedIndex == index)
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.teal.withValues(),
                shape: BoxShape.circle,
              ),
            ),
          Icon(icon, color: Colors.black),
        ],
      ),
    );
  }
}
