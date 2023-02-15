import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:trek_bkk_app/app/pages/history.dart';
import 'package:path/path.dart';
import 'package:trek_bkk_app/app/pages/login/login_view.dart';
import 'package:trek_bkk_app/app/pages/preference_survey.dart';

class Me extends StatelessWidget {
  const Me({super.key});

  void changePage(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/History');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const SignInPage())));
              },
              child: const Text("SignInPage")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const PreferenceSurvey())));
              },
              child: const Text("preference survey"))
        ],
      )),
    );
  }
}
