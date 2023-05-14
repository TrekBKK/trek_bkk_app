import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:trek_bkk_app/app/pages/login/login_view.dart';
import 'package:trek_bkk_app/app/pages/me/profile.dart';
import 'package:trek_bkk_app/app/pages/me/preference_survey.dart';

import '../../../providers/user.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserData>(
          builder: (context, userProvider, child) {
            if (userProvider.isloading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (userProvider.isfilled == false) {
              return const SignInPage();
            } else if (userProvider.user == null) {
              return const Text(
                  'Error fetching user data. cant create user model');
            } else {
              if (userProvider.checkPref()) {
                return ProfilePage(user: userProvider.user);
              } else {
                return const PreferenceSurvey();
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
  //             // : _pref == false
  //             //     ? const PreferenceSurvey()
  //             : ProfilePage()),
  //   );
  // }
}
