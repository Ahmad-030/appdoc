import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/body/aboutdoctor.dart';
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/body/excerise.dart';
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/body/medicine.dart';
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/body/patient.dart';
import 'package:doctorappflutter/AdminPanel/Dashboard/bottomnav/body/report.dart';
import 'package:doctorappflutter/AdminPanel/controller/bottomcontroller.dart';
import 'package:doctorappflutter/constant/constantfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../DashboardScreen/bottomnavscreens/settingscreen.dart';

class Adminnavbottom extends StatefulWidget {
  @override
  State<Adminnavbottom> createState() => _NavbottomState();
}

class _NavbottomState extends State<Adminnavbottom> {
  final Bottomcontroller _bottomcontroller = Get.put(Bottomcontroller());

  final List<Widget> _pages = [

    Patient(),
    Aboutdoctor(),
    Excerise(),
    Profile()
  ];

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.apps, 'label': 'Patient'},
    {'icon': Icons.people, 'label': 'Profile'},
    {'icon': Icons.fitness_center, 'label': 'Exercise'},
    {'icon': Icons.settings, 'label': 'Setting'}
  ];

  // Method to build navigation items
  List<Widget> _buildItems() {
    return _navItems.map((item) {
      int index = _navItems.indexOf(item);
      bool isSelected = _bottomcontroller.selectedIndex.value == index;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item['icon'],
            size: 30,
            color: Colors.white,
          ),
          // Show label only if not selected
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
      body: Obx(() => _pages[_bottomcontroller.selectedIndex.value]),
      bottomNavigationBar: Obx(() {
        return CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _bottomcontroller.selectedIndex.value,
          height: 70.0,
          backgroundColor: Colors.white,
          color: customBlue,
          buttonBackgroundColor: customBlue,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          items: _buildItems(), // Custom items
          onTap: (index) {
            _bottomcontroller.changeIndex(index);
          },
        );
      }),
    );
  }
}
