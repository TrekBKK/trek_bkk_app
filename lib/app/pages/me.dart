import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:trek_bkk_app/app/widgets/me_menu.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:trek_bkk_app/app/pages/history.dart';
import 'package:path/path.dart';
import 'package:trek_bkk_app/app/pages/login/login_view.dart';
import 'package:trek_bkk_app/app/pages/preference_survey.dart';

class Me extends StatelessWidget {
  const Me({super.key});
  final login = false;
  // void changePage(BuildContext ctx) {
  //   Navigator.of(ctx).pushNamed('/History');
  // }

  @override
  Widget build(BuildContext context) {
    // return login ? buildMeScene() : SignInPage();
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

Widget buildMeScene() => Scaffold(
      body: SafeArea(
          child: Container(
        // width: double.infinity,
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child: Column(children: <Widget>[
          Align(alignment: Alignment(1, 0), child: buildSettings()),
          Flexible(flex: 2, fit: FlexFit.tight, child: buildProfile()),
          Flexible(flex: 7, fit: FlexFit.tight, child: MeMenu()),
        ]),
      )),
    );

Widget buildSettings() =>
    IconButton(onPressed: (() {}), icon: Icon(Icons.settings));

Widget buildProfile() => Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: Row(
        children: [
          const CircleAvatar(
              radius: 60,
              backgroundImage:
                  NetworkImage('https://picsum.photos/250?image=9')),
          Container(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('userName temp'),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(width: 1, color: Colors.black)),
                  child: LinearPercentIndicator(
                    width: 120.0,
                    lineHeight: 15.0,
                    percent: 0.2,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    barRadius: const Radius.circular(16),
                    progressColor: Colors.blue[400],
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 5),
                const Text('3 places visited'),
              ],
            ),
          )
        ],
      ),
    );
