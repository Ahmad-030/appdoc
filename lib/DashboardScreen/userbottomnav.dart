import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doctorappflutter/DashboardScreen/bottomnavscreens/exercisescreen.dart';
import 'package:doctorappflutter/DashboardScreen/bottomnavscreens/homescreens.dart';
import 'package:doctorappflutter/DashboardScreen/bottomnavscreens/settingscreen.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:doctorappflutter/controllerclass/bottomnavigationcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Userbottomnav extends StatelessWidget {
  final Bottomnavigationcontroller _bottomnavigationcontroller =
  Get.put(Bottomnavigationcontroller());

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Define the list of pages
  final List<Widget> _pages = [
    Homescreens(),
    Exercisescreen(),
    Profile(),
  ];

  // Navigation bar items with names
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.fitness_center, 'label': 'Exercise'},
    {'icon': Icons.person, 'label': 'Profile'},
  ];

  // Build navigation items dynamically
  List<Widget> _buildItems() {
    return _navItems.map((item) {
      int index = _navItems.indexOf(item);
      bool isSelected = _bottomnavigationcontroller.selectedIndex.value == index;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item['icon'],
            size: 30,
            color: Colors.white,
          ),
          // Show the label only for unselected items
          if (!isSelected)
            Text(
              item['label'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Observe the selected index and load the corresponding page
      body: Obx(() => _pages[_bottomnavigationcontroller.selectedIndex.value]),
      bottomNavigationBar: Obx(() {
        return CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _bottomnavigationcontroller.selectedIndex.value,
          height: 70.0, // Height of the navigation bar
          backgroundColor: Colors.white, // Background of the main screen
          color: customBlue, // Navigation bar color
          buttonBackgroundColor: customBlue, // Highlighted button color
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          items: _buildItems(), // Generate navigation items dynamically
          onTap: (index) {
            _bottomnavigationcontroller.changeIndex(index); // Update selected index
          },
        );
      }),
    );
  }
}
