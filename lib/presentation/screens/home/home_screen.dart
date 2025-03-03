import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/home_provider.dart';
import 'package:wtsp_clone/presentation/components/bottom_navBar.dart';
import 'package:wtsp_clone/presentation/components/pop_up_menu.dart';
import 'package:wtsp_clone/presentation/screens/calls/call_screen.dart';
import 'package:wtsp_clone/presentation/screens/chats/chats_screen.dart';
import 'package:wtsp_clone/presentation/screens/communities/comunities_screen.dart';
import 'package:wtsp_clone/presentation/screens/updates/updates_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    ChatsScreen(),
    UpdatesScreen(),
    CommunitiesScreen(),
    CallsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: homeProvider.selectedIndex == 0 ? appBar() : null,
      body: _pages[homeProvider.selectedIndex],
      bottomNavigationBar: BottomNavbar(),
    );
  }

  AppBar appBar() {
    return AppBar(
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
        PopupMenu(),
      ],
    );
  }
}
