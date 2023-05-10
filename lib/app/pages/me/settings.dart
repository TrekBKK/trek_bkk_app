import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/app/pages/me/me.dart';
import 'package:trek_bkk_app/app/pages/me/preference_survey.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/providers/user.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = [
      {
        "title": "Redo Preference Survey",
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => const PreferenceSurvey())));
        }
      },
      {
        "title": "Log out",
        "onTap": () {
          Provider.of<UserData>(context, listen: false).clear();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: ((context) => const MePage())),
              (route) => false);
        }
      }
    ];

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(color: lightButDarkerColor),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                )),
            for (Map setting in settings)
              InkWell(
                onTap: setting["onTap"],
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                      color: dividerColor,
                      border:
                          Border(bottom: BorderSide(color: secondaryColor))),
                  child: Text(setting["title"]),
                ),
              )
          ],
        ),
      ),
    );
  }
}
