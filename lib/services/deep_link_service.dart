// lib/services/deep_link_service.dart

import 'dart:developer';
import 'package:get/get.dart';
import '../data/repositories/storage_repository.dart';
import '../presentation/routes/app_routes.dart';
import '../controllers/team_mode_controller/create_team_controller.dart';
import '../utils/snackbar_helper.dart';

class DeepLinkService extends GetxService {
  String? _pendingTeamToken;

  /// Handle deep link URL (called from main.dart or route handler)
  void handleDeepLink(String link) {
    log('🔗 Deep link received: $link');
    
    try {
      final uri = Uri.parse(link);
      
      // Check if it's a team join link
      if (uri.scheme == 'okrnav' && uri.host == 'join') {
        final teamToken = uri.queryParameters['code'];
        
        if (teamToken != null && teamToken.isNotEmpty) {
          log('✅ Team token extracted: $teamToken');
          _pendingTeamToken = teamToken;
          _processTeamJoin(teamToken);
        } else {
          SnackbarHelper.error('Invalid team invite link');
        }
      }
    } catch (e) {
      log('Error parsing deep link: $e');
      SnackbarHelper.error('Invalid invite link');
    }
  }

  /// Process team join - check if user is logged in
  void _processTeamJoin(String teamToken) {
    _pendingTeamToken = teamToken; // Store token first
    final storageRepository = Get.find<StorageRepository>();
    final user = storageRepository.getUser();
    final accessToken = storageRepository.getAccessToken();

    // Check if user is logged in
    if (user != null && accessToken != null && accessToken.isNotEmpty) {
      // User is logged in, join team directly
      log('✅ User is logged in, joining team directly');
      _joinTeamAndNavigate(teamToken);
    } else {
      // User is not logged in, navigate to login with token
      log('⚠️ User not logged in, navigating to login with token');
      Get.toNamed(
        AppRoutes.login,
        arguments: {'teamToken': teamToken},
      );
    }
  }

  /// Set pending team token (called from login screen with arguments)
  void setPendingTeamToken(String token) {
    _pendingTeamToken = token;
    log('✅ Pending team token set: $token');
  }

  /// Join team and navigate to lobby
  Future<void> _joinTeamAndNavigate(String teamToken) async {
    try {
      final createTeamController = Get.find<CreateTeamController>();
      
      // Set the team token in the controller
      createTeamController.teamCodeController.text = teamToken;
      
      // Call join team
      await createTeamController.joinTeam();
      
      // Clear pending token
      _pendingTeamToken = null;
    } catch (e) {
      log('Error joining team via deep link: $e');
      SnackbarHelper.error('Failed to join team. Please try again.');
    }
  }

  /// Get pending team token (used after login)
  String? getPendingTeamToken() => _pendingTeamToken;

  /// Clear pending team token
  void clearPendingTeamToken() {
    _pendingTeamToken = null;
  }

  /// Handle team join after successful login
  Future<void> handleTeamJoinAfterLogin() async {
    if (_pendingTeamToken != null) {
      await _joinTeamAndNavigate(_pendingTeamToken!);
    }
  }
}

