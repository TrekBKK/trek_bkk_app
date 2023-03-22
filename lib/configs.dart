import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

String apiUrl = defaultTargetPlatform == TargetPlatform.android
    ? '10.0.2.2:8000'
    : 'localhost:8000';

http.Client client = http.Client();
