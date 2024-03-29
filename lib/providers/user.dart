import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trek_bkk_app/configs.dart';
import 'package:trek_bkk_app/domain/entities/propose.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';
import 'package:trek_bkk_app/domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trek_bkk_app/domain/usecases/get_routes.dart';

class UserData with ChangeNotifier {
  UserModel? _user;
  late List<RouteHistoryModel> routeHistory = [];
  late List<RouteModel> routeFavorite = [];
  late List<ProposeModel> routePropose = [];

  bool _isfilled = false;
  bool _isloading = false;
  List<String> testFe = [];

  UserModel? get user => _user;
  bool get isfilled => _isfilled;
  bool get isloading => _isloading;

  bool checkHaveUser() {
    return _user != null;
  }

  bool checkUserRouteInfo() {
    if (routeHistory.isEmpty && routeFavorite.isEmpty && routePropose.isEmpty) {
      return false;
    }
    return true;
  }

  bool checkPref() {
    if (checkHaveUser() == false) {
      return false;
    }
    if (_user!.preference.distance != '' &&
        _user!.preference.distance != '' &&
        _user!.preference.type.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool checkFav(String routeId) {
    if (checkHaveUser() == true) {
      if (_user!.favoriteRoutes.contains(routeId)) {
        return true;
      }
    }
    return false;
  }

  Future<void> addHistoryRoute(RouteModel route) async {
    if (checkHaveUser() == false) {
      print("have no user(how the hell you can call this function)");
      return;
    }

    try {
      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat('E, dd MMM yyyy HH:mm:ss Z');
      String dateNow = dateFormat.format(now);

      final url = Uri.http(apiUrl, "/user/history");
      final http.Response response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'user_id': _user!.id,
            'route_id': route.id,
            'timestamp': dateNow
          }));
      if (response.statusCode == 200) {
        RouteHistoryModel temp = RouteHistoryModel(
            route: route, timestamp: dateFormat.parse(dateNow));
        RouteHistory temp2 =
            RouteHistory(routeId: route.id, timestamp: dateNow);
        _user!.routesHistory.add(temp2);
        routeHistory.add(temp);

        notifyListeners();
      } else {
        print('Failed to adding history route .');
      }
    } catch (error) {
      print('Error adding history route: $error');
    }
  }

  Future<void> updateFavRoute(RouteModel route) async {
    if (checkHaveUser() == false) {
      print("have no user(how the hell you can call this function)");
      return;
    }
    try {
      final url = Uri.http(apiUrl, "/user/favorite");
      final http.Response response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'user_id': _user!.id,
            'route_id': route.id,
          }));
      if (response.statusCode == 200) {
        if (_user!.favoriteRoutes.contains(route.id)) {
          _user!.favoriteRoutes.remove(route.id);
          routeFavorite.removeWhere((e) => e.id == route.id);
        } else {
          _user!.favoriteRoutes.add(route.id);
          routeFavorite.add(route);
        }
        notifyListeners();
      } else {
        print('Failed to updating favorite route .');
      }
    } catch (error) {
      print('Error updating favorite route: $error');
    }
  }

  Future<void> addPreference(String distance, stop, List<String> type) async {
    if (checkHaveUser() == false) {
      print("have no user");
      return;
    }
    try {
      _user!.preference.distance = '';
      _user!.preference.stop = '';
      _user!.preference.type = [];
      final url = Uri.http(apiUrl, "/user/pref");
      final http.Response response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'name': _user!.name,
            'email': _user!.name,
            'preference': {"distance": distance, "stop": stop, "type": type},
          }));
      if (response.statusCode == 200) {
        _user!.preference.distance = distance;
        _user!.preference.stop = stop;
        _user!.preference.type = type;
        notifyListeners();
      } else {
        print('Failed to save user information.');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> getUserInfo() async {
    if (checkHaveUser() == false) {
      print("have no user");
      return;
    }
    String userId = _user!.id;
    routeFavorite = await getFavoriteRoutes(userId);
    routeHistory = await getHistoryRoutes(userId);
    routePropose = await getProposedRoutes(userId);
    //get proposeRoute
  }

  Future<void> getUser(String name, email, [photoUrl]) async {
    try {
      _isloading = true;
      notifyListeners();
      SharedPreferences sp = await SharedPreferences.getInstance();
      final url = Uri.http(apiUrl, "/user/");
      final http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': name,
            'email': email,
            'photo': photoUrl ?? ""
          }));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _user = UserModel.fromJson(data);
        sp.setString("name", _user!.name);
        sp.setString("email", _user!.email);
      } else {
        print('Failed to save user information.');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    } finally {
      _isfilled = true;
      _isloading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserImage(String name, email, photoUrl) async {
    try {
      final url = Uri.http(apiUrl, "/user/image");
      final http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': name,
            'email': email,
            'photo': photoUrl
          }));
      if (response.statusCode == 200) {
        _user!.photoUrl = photoUrl;
      } else {
        print('Failed to edit user image.');
      }
    } catch (error) {
      print('Error editing user image: $error');
    } finally {
      notifyListeners();
    }
  }

  void clear() {
    _isfilled = false;
    _user = null;
    routeHistory.clear();
    routeFavorite.clear();
    routePropose.clear();
    notifyListeners();
  }
}
