import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<User?> signInWithGoogle() async {
    try {
      log("Starting Firebase + Google Sign-In...");

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        log("Sign-in cancelled");
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        log("Firebase login successful: ${user.displayName}");
        return user;
      }

      return null;
    } catch (e, s) {
      log("Firebase Google Sign-In error: $e", stackTrace: s);
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
// import 'dart:developer';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class GoogleAuthService {
//   // REPLACE WITH YOUR WEB CLIENT ID FROM FIREBASE CONSOLE
//   // static const String _webClientId =
//   //     '455927424272-18l6kogrvnqtkj3fal55qipk27iff3je.apps.googleusercontent.com';
//
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email', 'profile'],
//     // clientId: _webClientId, // REQUIRED for idToken
//   );
//
//   Future<Map<String, String>?> signInWithGoogle() async {
//     try {
//       log("Attempting Google sign-in...");
//
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         log("Google sign-in cancelled by user");
//         return null;
//       }
//
//       final GoogleSignInAuthentication googleAuth =
//       await googleUser.authentication;
//
//       final String? idToken = googleAuth.idToken;
//       final String? accessToken = googleAuth.accessToken;
//
//       if (idToken == null) {
//         log("ERROR: idToken is null. Check:");
//         log("   1. google-services.json in android/app/");
//         log("   2. SHA-1 in Firebase Console");
//         log("   3. Web client ID in AndroidManifest.xml");
//         log("   4. clientId in GoogleSignIn()");
//         return null;
//       }
//
//       log("idToken received: ${idToken.substring(0, 30)}...");
//
//       return {
//         'idToken': idToken,
//         'accessToken': accessToken ?? '',
//         'email': googleUser.email,
//         'displayName': googleUser.displayName ?? '',
//         'photoUrl': googleUser.photoUrl ?? '',
//       };
//     } catch (e, s) {
//       log("Google sign-in error: $e", stackTrace: s);
//       return null;
//     }
//   }
//
//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     log("Google sign-out completed");
//   }
// }