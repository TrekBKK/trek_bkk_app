import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trek_bkk_app/app/widgets/home_card.dart';
import 'package:trek_bkk_app/app/widgets/place_type_card.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/repositories/google_singin_api.dart';
import 'package:trek_bkk_app/domain/usecases/get_route_types.dart';
import 'package:trek_bkk_app/providers/user.dart';

import 'package:trek_bkk_app/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _availableTypes = [];

  @override
  void initState() {
    super.initState();
    _checkLogin();
    _getAvailableTypes();
  }

  void _getAvailableTypes() async {
    List types = await getRouteTypes();
    setState(() {
      _availableTypes = types;
    });
  }

  Future<void> _checkLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    String? _name = sp.getString("name");
    String? _email = sp.getString("email");
    print("check have user info or not<Home page> ${_name} ${_email}");

    if (context.mounted) {
      if (_name != null && _email != null) {
        //have user information in local storage -> call BE to get user instance
        await Provider.of<UserData>(context, listen: false)
            .getUser(_name, _email);
      } else {
        // first time logging in
      }
    }
  }

  Future _logout() async {
    await GoogleSignInApi.logout();
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("name");
    sp.remove("email");
    if (context.mounted) {
      Provider.of<UserData>(context, listen: false).clear();
    }
  }

  // void _registerCallBack() {
  //   setState(() {
  //     _login = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              const Image(
                image: AssetImage("assets/images/banner.png"),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: const Color(0xFFFFF9EB).withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const LimitedBox(
                            maxWidth: 196,
                            child: Text(
                              "Discover the \nhidden gems of BKK",
                              style: headline22,
                            )),
                        ElevatedButton(
                            onPressed: _logout,
                            style: primaryButtonStyles(),
                            child: const Text("Explore"))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Flexible(
          child: ListView(children: [
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Featured routes",
                style: headline22,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(children: const [
                  HomeCard(
                    title: "Springdale but also very long",
                    description:
                        "city of god of the millenial puzzle and very longlong text text text",
                    stops: 8,
                    distance: 3.7,
                  ),
                  HomeCard(
                    title: "ayodaya",
                    description: "city of god",
                    stops: 3,
                    distance: 3.7,
                  ),
                  HomeCard(
                      title: "title",
                      description: "descripto",
                      stops: 332,
                      distance: 3.772)
                ]),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Just for you",
                style: headline22,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(children: const [
                  HomeCard(
                    title: "ayodaya",
                    description: "city of god",
                    stops: 3,
                    distance: 3.7,
                  ),
                  HomeCard(
                    title: "ayodaya",
                    description: "city of god",
                    stops: 3,
                    distance: 3.7,
                  )
                ]),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Explore New Destination",
                style: headline22,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                    children: (_availableTypes.toList()..shuffle())
                        .map((typeKey) => PlaceTypeCard(type: typeKey))
                        .toList()),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
          ]),
        )
      ],
    );
  }
}
