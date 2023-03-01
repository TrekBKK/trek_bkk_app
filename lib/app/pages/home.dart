import 'package:flutter/material.dart';

import 'package:trek_bkk_app/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                              "Discover the hidden gems of BKK",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            )),
                        ElevatedButton(
                            onPressed: () {},
                            style: primaryButtonStyles(),
                            child: const Text("Explore"))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
