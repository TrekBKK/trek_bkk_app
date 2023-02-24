// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trek_bkk_app/app/pages/main_screen.dart';
import 'package:trek_bkk_app/providers/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.light(primary: Color(0xFF972D07))),
        home: MultiProvider(providers: [
          ChangeNotifierProvider(
            create: ((context) => UserData()),
          )
        ], child: MainScreen()));
  }
}
