import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trek_bkk_app/app/pages/main_screen.dart';
import 'package:trek_bkk_app/utils.dart';

class LocationPermissionPage extends StatefulWidget {
  const LocationPermissionPage({super.key});

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  @override
  void initState() {
    super.initState();

    checkLocationPermission();
  }

  checkLocationPermission() async {
    LocationPermission permission;
    bool serviceEnabled;

    permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.always ||
        permission != LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always ||
          permission != LocationPermission.whileInUse) {
        return;
      }
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.microtask(() => Geolocator.getCurrentPosition());
      return;
    }

    Future.microtask(() => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: ((context) => MainScreen()))));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 160, bottom: 48),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("data"),
                    SizedBox(
                      height: 48,
                    ),
                    Text("Location access is important"),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        "We need location data to provide you \na seamless walking experience")
                  ],
                ),
                ElevatedButton(
                    style: primaryButtonStyles(px: 8, py: 16),
                    onPressed: checkLocationPermission,
                    child: const Text("ALLOW"))
              ]),
        ),
      ),
    );
  }
}
