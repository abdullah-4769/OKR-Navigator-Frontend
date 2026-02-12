import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  // Use Android Client ID
  static const String serverClientId = "747676438342-hpitqg8o779bd383gfvj3bv9uheqp9.apps.googleusercontent.com";

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: serverClientId, // This makes token use Android Client ID
  );

  Future<String?> signInWithGoogle() async {
    try {
      print("=== GOOGLE SIGN-IN WITH ANDROID CLIENT ID ===");

      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("User cancelled");
        return null;
      }

      print("User: ${googleUser.email}");
      final auth = await googleUser.authentication;

      print("ID Token exists: ${auth.idToken != null}");
      print("Access Token exists: ${auth.accessToken != null}");

      return auth.idToken;
    } catch (e) {
      print("Google Sign-in Error: $e");
      return null;
    }
  }
}


// import 'dart:developer';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class GoogleAuthService {
//   Future<String?> signInWithGoogle() async {
//     try {
//       print("=== GOOGLE SIGN-IN STARTED ===");
//
//       // Simple Google Sign-in (same as test button)
//       final GoogleSignIn googleSignIn = GoogleSignIn();
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//
//       if (googleUser == null) {
//         print("User cancelled");
//         return null;
//       }
//
//       print("User: ${googleUser.email}");
//       final auth = await googleUser.authentication;
//
//       print("ID Token exists: ${auth.idToken != null}");
//       print("Access Token exists: ${auth.accessToken != null}");
//
//       return auth.idToken;
//     } catch (e) {
//       print("Google Sign-in Error: $e");
//       return null;
//     }
//   }
// }



// // lib/services/google_auth_service.dart
// import 'dart:developer';
// import 'package:google_sign_in/google_sign_in.dart';
//
//
// class GoogleAuthService {
//
//   static const String webClientId = "747676438342-otlkkkofdvhem2obkpennds5r4mc3b5d.apps.googleusercontent.com";
//
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email', 'profile'],
//     serverClientId: webClientId,
//   );
//   // static const String webClientId = "1016249703708-muc5a4jujc06930ir01kc6mg5rrlniop.apps.googleusercontent.com";
//   //
//   // final GoogleSignIn _googleSignIn = GoogleSignIn(
//   //   scopes: ['email', 'profile'],
//   //   serverClientId: webClientId,
//   // );
//
//   Future<String?> signInWithGoogle() async {
//     try {
//       log("Attempting Google Sign-In...");
//       final googleUser = await _googleSignIn.signIn();
//
//       if (googleUser == null) {
//         log("User cancelled Google Sign-In");
//         return null;
//       }
//
//       log("Google user selected: ${googleUser.email}");
//       final auth = await googleUser.authentication;
//
//       log("ID Token received: ${auth.idToken != null}");
//       log("Access Token received: ${auth.accessToken != null}");
//
//       if (auth.idToken == null) {
//         log("ERROR: No ID token received from Google");
//         return null;
//       }
//
//       return auth.idToken;
//     } catch (e, stack) {
//       log("Google sign in error: $e");
//       log("Stack trace: $stack");
//       return null;
//     }
//   }
// }