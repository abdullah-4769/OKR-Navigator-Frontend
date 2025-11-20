// lib/services/google_auth_service.dart
import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static const String webClientId = "1016249703708-muc5a4jujc06930ir01kc6mg5rrlniop.apps.googleusercontent.com";

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: webClientId,
  );

  Future<String?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final auth = await googleUser.authentication;
      return auth.idToken; // یہ idToken backend کو بھیجیں گے
    } catch (e) {
      log("Google sign in error: $e");
      return null;
    }
  }
}