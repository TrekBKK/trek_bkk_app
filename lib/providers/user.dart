import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trek_bkk_app/configs.dart';
import 'package:trek_bkk_app/domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserData with ChangeNotifier {
  UserModel? _user;
  bool _isfilled = false;

  UserModel? get user => _user;
  bool get isfilled => _isfilled;

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

  Future<void> addPreference(String distance, stop, List<String> type) async {
    if (checkHaveUser() == false) {
      print("have no user(how the hell you can call this function)");
      return;
    }
    try {
      final url = Uri.https(apiUrl, "/user/pref");
      final http.Response response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'name': _user!.name,
            'email': _user!.name,
            'preference': {"distance": distance},
          }));
      if (response.statusCode == 200) {
        print("success");
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

  Future<void> getUser(String name, email, [photoUrl]) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      final url = Uri.https(apiUrl, "/user/");
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
      notifyListeners();
    }
  }

  void clear() {
    _isfilled = false;
    _user = null;
    notifyListeners();
  }
}
