import 'package:bithabit/src/pages/dash/dash_page.dart';
import 'package:bithabit/src/pages/recap/recap_page.dart';
import 'package:bithabit/src/pages/setting/setting_page.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  late final pageController = PageController(initialPage: currentPageIndex);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: pageController,
        children: const [
          DashPage(),
          RecapPage(),
          SettingPage(),
        ],
        onPageChanged: (value) {
          setState(() => currentPageIndex = value);
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: CustomNavigationBar(
          currentIndex: currentPageIndex,
          elevation: 4,
          borderRadius: const Radius.circular(12),
          onTap: (index) => pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          ),
          isFloating: true,
          items: [
            CustomNavigationBarItem(
              icon: const Icon(BoxIcons.bx_rocket),
              selectedIcon: const Icon(BoxIcons.bxs_rocket),
            ),
            CustomNavigationBarItem(
              icon: const Icon(BoxIcons.bx_calendar_check),
              selectedIcon: const Icon(BoxIcons.bxs_calendar_check),
            ),
            CustomNavigationBarItem(
              icon: const Icon(BoxIcons.bx_user),
              selectedIcon: const Icon(BoxIcons.bxs_user),
            ),
          ],
        ),
      ),
    );
  }
}