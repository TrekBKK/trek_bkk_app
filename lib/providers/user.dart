import 'package:flutter/cupertino.dart';
import 'package:trek_bkk_app/domain/entities/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class UserData with ChangeNotifier {
  late UserModel _user;

  UserModel get user => _user;

  void saveUser(UserModel user) {
    _user = user;
    print(_user);
    // print('before sending the data');
    _checkUser(_user);
    // print('after sending the data');

    notifyListeners();
  }

  Future<void> _checkUser(UserModel user) async {
    String url =
        Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://localhost:8000';
    // final http.Response response = await http.post(
    //   Uri.parse('http://localhost:8080/temp02'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'name': 'th',
    //   }),
    // );

    // final http.Response response = await http.get(Uri.parse('${url}'));
    final http.Response response = await http.post(Uri.parse('${url}/user/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'name': user.name!, 'email': user.email!}));

    print(response);

    if (response.statusCode == 200) {
      print('User information saved successfully.');
    } else {
      print('Failed to save user information.');
    }
  }
}
