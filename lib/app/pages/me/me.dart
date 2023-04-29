import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trek_bkk_app/app/pages/login/login_view.dart';
import 'package:trek_bkk_app/app/pages/me/profile.dart';
import 'package:trek_bkk_app/app/widgets/me_menu.dart';

import 'package:trek_bkk_app/app/pages/me/preference_survey.dart';
import 'package:trek_bkk_app/domain/entities/user.dart';

import '../../../providers/user.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  bool _login = false;
  late bool _perf;

  @override
  void initState() {
    super.initState();
  }

  void _registerCallBack() {
    setState(() {
      _login = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserData>(
          builder: (context, userProvider, child) {
            if (userProvider.isfilled == false) {
              return SignInPage();
            } else if (userProvider.user == null) {
              return const Text('Error fetching user data');
            } else {
              if (userProvider.user!.perference == true) {
                return ProfilePage();
              } else {
                return PreferenceSurvey();
              }
            }
          },
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   bool _login = false;
  //   _login = Provider.of<UserData>(context, listen: false).checkLogin();
  //   print("$_login in mme page");
  //   return Scaffold(
  //     body: SafeArea(
  //         child: _login == false
  //             ? SignInPage(callback: _registerCallBack)
  //             // : _perf == false
  //             //     ? const PreferenceSurvey()
  //             : ProfilePage()),
  //   );
  // }
}
