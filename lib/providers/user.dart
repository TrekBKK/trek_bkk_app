import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trek_bkk_app/configs.dart';
import 'package:trek_bkk_app/domain/entities/route.dart';
import 'package:trek_bkk_app/domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trek_bkk_app/domain/usecases/get_routes.dart';

class UserData with ChangeNotifier {
  UserModel? _user;
  List<RouteHistoryModel>? routeHistory;
  List<RouteModel>? routeFavorite;

  bool _isfilled = false;
  bool _isloading = false;
  List<String> testFe = [];

  UserModel? get user => _user;
  bool get isfilled => _isfilled;
  bool get isloading => _isloading;

  bool checkHaveUser() {
    return _user != null;
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

  void tempp() {
    testFe.add("test state");
    print(routeFavorite!.length);
    notifyListeners();
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
          routeFavorite!.removeWhere((e) => e.id == route.id);
        } else {
          _user!.favoriteRoutes.add(route.id);
          routeFavorite!.add(route);
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

  void clear() {
    _isfilled = false;
    _user = null;
    notifyListeners();
  }
}
