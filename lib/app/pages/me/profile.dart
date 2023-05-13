import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/app/pages/me/settings.dart';
import 'package:trek_bkk_app/app/widgets/me_menu.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/entities/user.dart';
import 'package:trek_bkk_app/providers/user.dart';

class ProfilePage extends StatefulWidget {
  final UserModel? user;
  const ProfilePage({super.key, this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserData>(context, listen: false).user;
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  decoration: const BoxDecoration(color: lightColor),
                  child: Align(
                      alignment: Alignment(1, 0),
                      child: buildSettings(context))),
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: buildProfile(widget.user!.name)),
              Flexible(
                  flex: 7,
                  fit: FlexFit.tight,
                  child: MeMenu(user: widget.user)),
            ]),
      )),
    );
  }
}

Widget buildSettings(BuildContext context) => IconButton(
    onPressed: (() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Settings()));
    }),
    icon: const Icon(Icons.settings));

Widget buildProfile(name) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                Text("${name}"),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(width: 1, color: Colors.black)),
                  child: LinearPercentIndicator(
                    width: 120.0,
                    lineHeight: 15.0,
                    percent: 0.5,
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
