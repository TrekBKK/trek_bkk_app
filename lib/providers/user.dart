import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trek_bkk_app/configs.dart';
import 'package:trek_bkk_app/domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserData with ChangeNotifier {
  UserModel? _user;

  UserModel get user => _user!;

  Future<void> saveUser(UserModel user) async {
    _user = user;
    await _getUser(user);

    notifyListeners();
  }

  void checkLogin() {
    if (_user == null) {
      print("null");
    }
  }

  bool check() {
    return _user == null;
  }

  Future<void> _getUser(UserModel user) async {
    final http.Response response = await http.post(Uri.http(apiUrl, "/user/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'name': user.name, 'email': user.email}));

    _user = UserModel.fromJson(json.decode(response.body));
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString("name", user.name);
    sp.setString("email", user.email);
    print("response");
    print(_user);

    if (response.statusCode == 200) {
      print('User information saved successfully.');
    } else {
      print('Failed to save user information.');
    }
  }
}
