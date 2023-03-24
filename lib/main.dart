// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:trek_bkk_app/app/pages/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
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
        home: Splash());
  }
}
