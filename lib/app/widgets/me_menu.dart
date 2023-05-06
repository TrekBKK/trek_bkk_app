import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/app/pages/me/propose_tab.dart';
import 'package:trek_bkk_app/app/widgets/google_map/propose_route.dart';
import 'package:trek_bkk_app/app/widgets/route_card.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';
import 'package:trek_bkk_app/domain/entities/user.dart';
import 'package:trek_bkk_app/domain/usecases/get_routes.dart';
import 'package:trek_bkk_app/providers/user.dart';

class MeMenu extends StatefulWidget {
  const MeMenu({super.key});

  @override
  State<MeMenu> createState() => _MeMenuState();
}

class _MeMenuState extends State<MeMenu> {
  int _currentIndex = 0;
  List<RouteModel> _favRoutes = [];
  List<RouteHistoryModel> _historyRoutes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (context.mounted) {
      UserModel? user = Provider.of<UserData>(context, listen: false).user;
      _fetchData(user!.name, user.email);
    }
  }

  void _fetchData(String name, email) async {
    if (context.mounted) {
      _favRoutes = await getFavoriteRoutes(name, email);
      _historyRoutes = await getHistoryRoutes(name, email);
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                  ? const ProposeTab()
                  : _currentIndex == 1
                      ? _buildFav(_isLoading, _favRoutes)
                      : _buildHistory(_isLoading, _historyRoutes),
            ))
      ],
    );
  }
}

Widget _buildFav(bool isloading, List<RouteModel> routes) {
  return Container(
    child: isloading
        ? const CircularProgressIndicator()
        : ListView.builder(
            padding: const EdgeInsets.only(bottom: 36),
            itemCount: routes.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                child: RouteCard(
                  route: routes[index],
                  imgUrl: "https://picsum.photos/160/90",
                ),
              );
            }),
  );
}

Widget _buildHistory(bool isloading, List<RouteHistoryModel> routes) {
  //using another widget -> in case someone want to have fancy dateTime decoration
  return Container(
    child: isloading
        ? const CircularProgressIndicator()
        : ListView.builder(
            padding: const EdgeInsets.only(bottom: 36),
            itemCount: routes.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                child: RouteCard(
                  route: routes[index].route,
                  imgUrl: "https://picsum.photos/160/90",
                ),
              );
            }),
  );
}
