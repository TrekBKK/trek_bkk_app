import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/domain/repositories/auth_services.dart';
import 'package:trek_bkk_app/providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _showLoginAsGuest = false;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future googleSignIn() async {
      final AuthService authService = AuthService();
      User? res = await authService.googleLogin();
      if (res != null && context.mounted) {
        await Provider.of<UserData>(context, listen: false)
            .getUser(res.displayName!, res.email, res.photoURL ?? "");
      }
    }

    Future signInGuest(String name) async {
      if (context.mounted) {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('ddMMyyyyHHmmss').format(now);
        String email = '$name$formattedDate@tempmail.com';
        await Provider.of<UserData>(context, listen: false)
            .getUser(name, email, "");
      }
    }

    void _showPopup() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter Your Name"),
            content: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Your Name",
                      border: OutlineInputBorder(),
                      labelText: "Name",
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  child: Text("Send"),
                  onPressed: () {
                    String name = _textController.text;
                    signInGuest(name);
                  },
                ),
              ],
            ),
          );
          ;
        },
      );
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("assets/icons/signin.png"),
              ),
              const SizedBox(height: 48),
              const Text(
                  textAlign: TextAlign.center,
                  "Sign in to see your favorite list \nand propose your own route!"),
              const SizedBox(height: 48),
              OutlinedButton.icon(
                onPressed: googleSignIn,
                icon: const Image(
                    width: 16, image: AssetImage("assets/icons/google.png")),
                label: const Text("Sign in with Google"),
                style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith((states) =>
                        const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16))),
              ),
              const SizedBox(
                height: 8,
              ),
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Enter Your Name"),
                        content: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                decoration: InputDecoration(
                                  hintText: "Your Name",
                                  border: OutlineInputBorder(),
                                  labelText: "Name",
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              child: Text("Send"),
                              onPressed: () async {
                                String name = _textController.text;
                                signInGuest(name);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                      ;
                    },
                  );
                },
                icon: const Image(
                    width: 16, image: AssetImage("assets/icons/github.png")),
                label: const Text("Sign in as guest"),
                style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith((states) =>
                        const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16))),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
