import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/home_provider.dart';
import 'package:wtsp_clone/fireBaseview/screens/chats/chats_screen.dart';
import 'package:wtsp_clone/view/components/bottom_navBar.dart';
import 'package:wtsp_clone/view/components/pop_up_menu.dart';
import 'package:wtsp_clone/view/screens/calls/call_screen.dart';
import 'package:wtsp_clone/view/screens/communities/comunities_screen.dart';
import 'package:wtsp_clone/view/screens/updates/updates_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    //ChatsScreen(),
    FirebaseChatsScreen(),
    UpdatesScreen(),
    CommunitiesScreen(),
    CallsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: homeProvider.selectedIndex == 0
          ? _appBar(context, homeProvider)
          : null,
      body: _pages[homeProvider.selectedIndex],
      bottomNavigationBar: BottomNavbar(),
    );
  }

  AppBar _appBar(BuildContext context, HomeProvider homeProvider) {
    return AppBar(
      title: Text(
        "WhatsApp",
        style: TextStyle(
          color: Color.fromARGB(255, 108, 193, 149),
          //color:Color.fromARGB(255, 107, 200, 152),
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
            //homeProvider.captureImageFromCamera();
            homeProvider.pickImageFromGallery();
          },
        ),
        PopupMenu(),
      ],
    );
  }
}
