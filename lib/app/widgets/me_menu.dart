import 'package:flutter/material.dart';

class MeMenu extends StatefulWidget {
  const MeMenu({super.key});

  @override
  State<MeMenu> createState() => _MeMenuState();
}

class _MeMenuState extends State<MeMenu> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: _currentIndex == 0
                                    ? const Color(0xff972d07)
                                    : Colors.white))),
                    child: Column(
                      children: [
                        IconButton(
                          icon: _currentIndex == 0
                              ? Image.asset("assets/icons/routeA.png")
                              : Image.asset("assets/icons/routeU.png"),
                          onPressed: () {
                            _currentIndex != 0
                                ? setState(() {
                                    _currentIndex = 0;
                                  })
                                : null;
                          },
                        ),
                        Text(
                          'Create my own',
                          style: _currentIndex == 0
                              ? const TextStyle(color: Color(0xff972d07))
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: _currentIndex == 1
                                    ? const Color(0xff972d07)
                                    : Colors.white))),
                    child: Column(
                      children: [
                        IconButton(
                          icon: _currentIndex == 1
                              ? Image.asset("assets/icons/favoriteA.png")
                              : Image.asset("assets/icons/favoriteU.png"),
                          onPressed: () {
                            _currentIndex != 1
                                ? setState(() {
                                    _currentIndex = 1;
                                  })
                                : null;
                          },
                        ),
                        Text(
                          'my favorite',
                          style: _currentIndex == 1
                              ? const TextStyle(color: Color(0xff972d07))
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: _currentIndex == 2
                                    ? const Color(0xff972d07)
                                    : Colors.white))),
                    child: Column(
                      children: [
                        IconButton(
                          icon: _currentIndex == 2
                              ? Image.asset("assets/icons/historyA.png")
                              : Image.asset("assets/icons/historyU.png"),
                          onPressed: () {
                            _currentIndex != 2
                                ? setState(() {
                                    _currentIndex = 2;
                                  })
                                : null;
                          },
                        ),
                        Text(
                          'History',
                          style: _currentIndex == 2
                              ? const TextStyle(color: Color(0xff972d07))
                              : null,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
        Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: AnimatedSwitcher(
              duration: const Duration(microseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: _currentIndex == 0
                  ? _buildOwnRoute()
                  : _currentIndex == 1
                      ? _buildFav()
                      : _buildHistory(),
            ))
      ],
    );
  }
}

Widget _buildOwnRoute() {
  return Text('rotues');
}

Widget _buildFav() {
  return Text('favorite');
}

Widget _buildHistory() {
  return Text('history');
}
