import 'package:flutter/foundation.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');

String apiUrl = defaultTargetPlatform == TargetPlatform.android
    ? isProduction
        ? "trekbkk.azurewebsites.net"
        : '10.0.2.2:8000'
    : 'localhost:8000';
