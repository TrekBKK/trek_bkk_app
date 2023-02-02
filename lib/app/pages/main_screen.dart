import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/pages/generate/generate_page.dart';
import 'package:trek_bkk_app/app/pages/history.dart';
import 'package:trek_bkk_app/app/pages/home.dart';
import 'package:trek_bkk_app/app/pages/me.dart';
import 'package:trek_bkk_app/app/pages/search/search_1.dart';
import 'package:trek_bkk_app/app/utils/icons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class MainScreen extends StatelessWidget {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  MainScreen({super.key});

  List<Widget> _buildScreens() {
    return const [Home(), Search1(), GeneratePage(), Me()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: const Color(0xff972d07),
        inactiveColorPrimary: Colors.grey[500],
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.search),
        title: ("search"),
        activeColorPrimary: const Color(0xff972d07),
        inactiveColorPrimary: Colors.grey[500],
      ),
      PersistentBottomNavBarItem(
        icon: const SizedBox(width: 100, child: Icon(CustomIcons.trek)),
        title: ("create"),
        activeColorPrimary: const Color(0xff972d07),
        inactiveColorPrimary: Colors.grey[500],
      ),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.account_circle),
          title: ("me"),
          activeColorPrimary: const Color(0xff972d07),
          inactiveColorPrimary: Colors.grey[500],
          routeAndNavigatorSettings: RouteAndNavigatorSettings(
            routes: {
              '/History': (context) => History(),
            },
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)?.settings.name);
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: const Color(0xfffff5df),
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
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}
