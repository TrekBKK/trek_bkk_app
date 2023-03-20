import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trek_bkk_app/app/pages/main_screen.dart';
import 'package:trek_bkk_app/app/pages/location_permission.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance
        .addPostFrameCallback((_) => checkLocationPermission());
  }

  checkLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if ((permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) &&
        await Geolocator.isLocationServiceEnabled()) {
      Future.microtask(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen())));
    } else {
      permission = await Geolocator.requestPermission();
      if ((permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse) &&
          await Geolocator.isLocationServiceEnabled()) {
        Future.microtask(() => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen())));
      } else {
        Future.microtask(() => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const LocationPermissionPage())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text("TREK BKK")],
      ),
    ));
  }
}
