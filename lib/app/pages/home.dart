import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/widgets/home_card.dart';
import 'package:trek_bkk_app/constants.dart';

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
              height: 32,
            )
          ]),
        )
      ],
    );
  }
}
