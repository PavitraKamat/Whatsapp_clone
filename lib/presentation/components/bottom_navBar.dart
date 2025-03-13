import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/home_provider.dart';

class BottomNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    int selectedIndex = homeProvider.selectedIndex;

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => homeProvider.updateIndex(index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF0D4D3E), 
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      items: [
        _buildNavItem(Icons.chat, "Chats", 0, selectedIndex),
        _buildNavItem(Icons.update, "Updates", 1, selectedIndex),
        _buildNavItem(Icons.groups, "Communities", 2, selectedIndex),
        _buildNavItem(Icons.call, "Calls", 3, selectedIndex),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index, int selectedIndex) {
    bool isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      label: label,
      icon: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Container(
              width: 50,
              height: 35,
              decoration: BoxDecoration(
                color: Color(0xFFDFF7DF), 
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          Icon(
            icon,
            color: isSelected ? Color(0xFF0D4D3E) : Colors.black,
          ),
        ],
      ),
    );
  }
}
