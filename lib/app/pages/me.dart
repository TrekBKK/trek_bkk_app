import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:trek_bkk_app/app/pages/history.dart';

class Me extends StatelessWidget {
  const Me({super.key});

  void changePage(BuildContext ctx) {
    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
      ctx,
      settings: RouteSettings(name: History.routeName),
      screen: History(),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
    // Navigator.of(ctx).pushNamed('/history',
    //     arguments: const RouteAndNavigatorSettings(routes: '/history'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: InkWell(
              onTap: () => changePage(context), child: Text('me page'))),
    );
  }
}
