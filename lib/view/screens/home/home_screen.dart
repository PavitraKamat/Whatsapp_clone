import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/home_provider.dart';
import 'package:wtsp_clone/fireBaseview/screens/chats/chats_screen.dart';
import 'package:wtsp_clone/view/components/bottom_navBar.dart';
import 'package:wtsp_clone/view/components/pop_up_menu.dart';
import 'package:wtsp_clone/view/screens/calls/call_screen.dart';
import 'package:wtsp_clone/view/screens/chats/chats_screen.dart';
import 'package:wtsp_clone/view/screens/communities/comunities_screen.dart';
import 'package:wtsp_clone/view/screens/updates/updates_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        final List<Widget> _pages = [
          homeProvider.isFirebaseView ? FirebaseChatsScreen() : ChatsScreen(),
          UpdatesScreen(),
          CommunitiesScreen(),
          CallsScreen(),
        ];

        return Scaffold(
          appBar: homeProvider.selectedIndex == 0
              ? _appBar(context, homeProvider)
              : null,
          body: _pages[homeProvider.selectedIndex],
          bottomNavigationBar: BottomNavbar(),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context, HomeProvider homeProvider) {
    return AppBar(
      title: Text(
        "WhatsApp",
        style: TextStyle(
          color: Color.fromARGB(255, 108, 193, 149),
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      actions: [
        IconButton(
          icon: Icon(Icons.qr_code_scanner),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.camera_alt_outlined),
          onPressed: () {
            homeProvider.pickImageFromGallery();
          },
        ),
        PopupMenu(),
      ],
    );
  }
}
