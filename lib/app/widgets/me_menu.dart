import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/app/pages/propose/propose_tab.dart';
import 'package:trek_bkk_app/app/widgets/route_card.dart';
import 'package:trek_bkk_app/constants.dart';
import 'package:trek_bkk_app/domain/entities/propose.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';
import 'package:trek_bkk_app/domain/entities/user.dart';
import 'package:trek_bkk_app/providers/user.dart';

class MeMenu extends StatefulWidget {
  final UserModel? user;
  const MeMenu({super.key, this.user});

  @override
  State<MeMenu> createState() => _MeMenuState();
}

class _MeMenuState extends State<MeMenu> {
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (context.mounted) {
      _fetchData();
    }
  }

  void _fetchData() async {
    if (context.mounted) {
      if (Provider.of<UserData>(context, listen: false).checkUserRouteInfo() ==
          false) {
        await Provider.of<UserData>(context, listen: false).getUserInfo();
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<RouteModel>? routeFavorite =
        Provider.of<UserData>(context, listen: false).routeFavorite;
    List<RouteHistoryModel> routeHistory =
        Provider.of<UserData>(context, listen: false).routeHistory;
    List<ProposeModel> routePropose =
        Provider.of<UserData>(context, listen: false).routePropose;
    return Column(
      children: [
        Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              decoration: const BoxDecoration(color: lightColor),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _currentIndex != 0
                            ? setState(() {
                                _currentIndex = 0;
                              })
                            : null;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 3,
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
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _currentIndex != 1
                            ? setState(() {
                                _currentIndex = 1;
                              })
                            : null;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 3,
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
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _currentIndex != 2
                            ? setState(() {
                                _currentIndex = 2;
                              })
                            : null;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 3,
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
                                  ? const TextStyle(
                                      color: Color(0xff972d07),
                                    )
                                  : null,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
                  ? ProposeTab(
                      isLoading: _isLoading, routePropose: routePropose)
                  : _currentIndex == 1
                      ? _buildFav(_isLoading, routeFavorite)
                      : _buildHistory(_isLoading, routeHistory),
            ))
      ],
    );
  }
}

Widget _buildFav(bool isloading, List<RouteModel>? routes) {
  return Container(
    child: isloading
        ? const CircularProgressIndicator()
        : ListView.builder(
            padding: const EdgeInsets.only(bottom: 36),
            itemCount: routes!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                child: RouteCard(
                  route: routes[index],
                  imgUrl: routes[index].imagePath == ''
                      ? "https://picsum.photos/160/90"
                      : routes[index].imagePath,
                ),
              );
            }),
  );
}

Widget _buildHistory(bool isloading, List<RouteHistoryModel>? routes) {
  //using another widget -> in case someone want to have fancy dateTime decoration
  return Container(
    child: isloading
        ? const CircularProgressIndicator()
        : ListView.builder(
            padding: const EdgeInsets.only(bottom: 36),
            itemCount: routes!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                child: RouteCard(
                  route: routes[index].route,
                  time: routes[index].timestamp,
                  imgUrl: routes[index].route.imagePath == ''
                      ? "https://picsum.photos/160/90"
                      : routes[index].route.imagePath,
                ),
              );
            }),
  );
}
