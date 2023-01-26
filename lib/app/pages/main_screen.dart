import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/pages/browse.dart';
import 'package:trek_bkk_app/app/pages/create.dart';
import 'package:trek_bkk_app/app/pages/home.dart';
import 'package:trek_bkk_app/app/pages/me.dart';
import 'package:trek_bkk_app/app/utils/icons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MainScreen extends StatelessWidget {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [Home(), Browse(), Create(), Me()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: const Color(0xff972d07),
        inactiveColorPrimary: Colors.grey[500],
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: ("search"),
        activeColorPrimary: const Color(0xff972d07),
        inactiveColorPrimary: Colors.grey[500],
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CustomIcons.trek),
        title: ("create"),
        activeColorPrimary: const Color(0xff972d07),
        inactiveColorPrimary: Colors.grey[500],
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        title: ("me"),
        activeColorPrimary: const Color(0xff972d07),
        inactiveColorPrimary: Colors.grey[500],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
<<<<<<< Updated upstream
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xfffff5df),
        selectedItemColor: Color(0xff972d07),
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        onTap: navigationTapped,
        currentIndex: _currentPage,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xfffff5df),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse',
            backgroundColor: Color(0xfffff5df),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.trek),
            label: 'Create',
            backgroundColor: Color(0xfffff5df),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Me',
            backgroundColor: Color(0xfffff5df),
          ),
        ],
=======
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
>>>>>>> Stashed changes
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: PageView(
  //         physics: const NeverScrollableScrollPhysics(),
  //         controller: _pageController,
  //         onPageChanged: onPageChanged,
  //         children: const <Widget>[
  //           Me(),
  //           Text('page2'),
  //           Text('page3'),
  //           Text('page4')
  //         ],
  //       ),
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       backgroundColor: const Color(0xfffff5df),
  //       selectedItemColor: const Color(0xff972d07),
  //       unselectedItemColor: Colors.grey[500],
  //       type: BottomNavigationBarType.fixed,
  //       onTap: navigationTapped,
  //       currentIndex: _currentPage,
  //       items: const <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.home),
  //           label: 'Home',
  //           backgroundColor: Color(0xfffff5df),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.search),
  //           label: 'Browse',
  //           backgroundColor: Color(0xfffff5df),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(CustomIcons.trek),
  //           label: 'Create',
  //           backgroundColor: Color(0xfffff5df),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.account_circle),
  //           label: 'Me',
  //           backgroundColor: Color(0xfffff5df),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
