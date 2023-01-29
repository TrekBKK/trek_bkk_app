import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:trek_bkk_app/app/pages/history.dart';
import 'package:path/path.dart';

class Me extends StatelessWidget {
  const Me({super.key});

  void changePage(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/History');
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
