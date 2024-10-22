// ignore_for_file: unused_import, prefer_const_constructors

import 'package:cric_trax/const/app_colors.dart';
import 'package:cric_trax/screen/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

import '../live_matches_screen/live_matches_screen.dart';
import '../live_mateches_screen/my_videos_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../setting_screen/setting_screen.dart';
import '../watch_screen/watch_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;
  List<Widget> screen = [
    const HomeScreen(),
    const WatchScreen(),
    const MyVideoScreen(),
    //ProfileScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: screen.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        showUnselectedLabels: false,
        unselectedItemColor: AppColors.kGreyColor,
        selectedItemColor: AppColors.kPrimaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.watch_later_outlined), label: 'Watch\t'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv_sharp), label: 'My Videos'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}
