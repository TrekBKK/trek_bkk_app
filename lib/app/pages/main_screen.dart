import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/utils/icons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: const <Widget>[
            Text('page1'),
            Text('page2'),
            Text('page3'),
            Text('page4')
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xfffff5df),
        selectedItemColor: const Color(0xff972d07),
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
      ),
    );
  }
}
