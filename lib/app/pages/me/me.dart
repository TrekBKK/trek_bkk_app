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
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    String? _name = sp.getString("name");
    String? _email = sp.getString("email");
    print("checkLogin");
    // print(Provider.of<UserData>(context, listen: false).user);

    if (context.mounted) {
      if (_name != null && _email != null) {
        UserModel _user = UserModel(name: _name, email: _email);
        Provider.of<UserData>(context, listen: false).saveUser(_user);
        setState(() {
          _login = true;
        });
      } else {
        setState(() {
          _login = false;
        });
      }
    }
  }

  void _registerCallBack() {
    setState(() {
      _login = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // bool _login = Provider.of<UserData>(context, listen: false).check();

    return Scaffold(
      body: SafeArea(
          child: _login == false
              ? SignInPage(callback: _registerCallBack)
              // : _perf == false
              //     ? const PreferenceSurvey()
              : ProfilePage()),
    );
  }
}
