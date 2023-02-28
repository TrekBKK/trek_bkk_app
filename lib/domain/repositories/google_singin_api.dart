import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = defaultTargetPlatform == TargetPlatform.android
      ? GoogleSignIn()
      : GoogleSignIn(
          clientId:
              '702654165149-kf217g11ek2t8hetdh2f26rgld0tn28p.apps.googleusercontent.com');
  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
}
