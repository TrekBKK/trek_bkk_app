import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/domain/repositories/google_singin_api.dart';
import 'package:trek_bkk_app/providers/user.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future googleSignIn() async {
      var res = await GoogleSignInApi.login();
      if (res != null && context.mounted) {
        await Provider.of<UserData>(context, listen: false)
            .getUser(res.displayName!, res.email, res.photoUrl ?? "");
      }
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
                onPressed: () {},
                icon: const Image(
                    width: 16, image: AssetImage("assets/icons/github.png")),
                label: const Text("Sign in with Github"),
                style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith((states) =>
                        const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16))),
              )
            ],
          ),
        ],
      )),
    );
  }
}
