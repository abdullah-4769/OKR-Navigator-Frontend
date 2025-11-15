// import 'package:flutter/foundation.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../services/google_auth_service.dart';
//
// class AuthProvider with ChangeNotifier {
//   final AuthService _authService = AuthService();
//
//   bool _isLoading = false;
//   bool _isAuthenticated = false;
//   Map<String, dynamic>? _userData;
//
//   bool get isLoading => _isLoading;
//   bool get isAuthenticated => _isAuthenticated;
//   Map<String, dynamic>? get userData => _userData;
//
//   AuthProvider() {
//     _initializeAuth();
//   }
//
//   Future<void> _initializeAuth() async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       // First check if we have stored tokens
//       _isAuthenticated = await _authService.isSignedIn();
//
//       if (_isAuthenticated) {
//         _userData = await _authService.getUserData();
//       } else {
//         // Try silent sign in if no stored tokens
//         final bool silentSuccess = await _authService.trySilentSignIn();
//         if (silentSuccess) {
//           _isAuthenticated = true;
//           _userData = await _authService.getUserData();
//         }
//       }
//
//       notifyListeners();
//     } catch (e) {
//       print('Auth initialization error: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> signInWithGoogle() async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       final response = await _authService.signInWithGoogle();
//       _userData = response?['user'];
//       _isAuthenticated = true;
//
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> signOut() async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       await _authService.signOut();
//       _isAuthenticated = false;
//       _userData = null;
//
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
//
//
