import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/features/history/screens/history_screen.dart';
import 'package:payment_app/features/home/screens/home_screen.dart';
import 'package:payment_app/features/scan/screens/scan_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int currentIndex = 0;
    List<Widget> screens = [HomeScreen(), HistoryScreen()];

    List<IconData> icons = [Icons.home, Icons.history];
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: screens[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ScanScreen()),
          );
        },
        child: Icon(Icons.qr_code_scanner, color: whiteColor, size: 20.h),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: icons,
        iconSize: 20.h,
        activeIndex: currentIndex,
        activeColor: themeColor,
        inactiveColor: greyColor,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        elevation: 3,
         onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
