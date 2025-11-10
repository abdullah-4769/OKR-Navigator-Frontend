// lib/repository/challange_repositories/challenge_accept_invitation_repository.dart

import '../../core/api_constants.dart';
import '../../data/network/network_api_services.dart';
import '../../generated/models/responses/challenge_mode/challenge_response_request.dart';


class ChallengeAcceptInvitationRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<List<dynamic>> getPlayerInvitations(String userId) async {
    try {
      final response = await _apiService.getGetApiResponse(
        ApiConstants.getChallengeInvitations(userId),
      );
      return response is List ? response : [];
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> respondToChallenge(int challengeId, String playerId, bool accept) async {
    try {
      final request = ChallengeResponseRequest(
        playerId: playerId,
        accept: accept,
      );

      final response = await _apiService.getPatchApiResponse(
        ApiConstants.respondToInvitation(challengeId),
        request.toJson(),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}






//
// // lib/repository/challange_repositories/challenge_accept_invitation_repository.dart
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../data/network/network_api_services.dart';
// import '../../generated/models/responses/challenge_mode/challenge_response_request.dart';
//
// class ChallengeAcceptInvitationRepository {
//   final NetworkApiService _apiService = NetworkApiService();
//
//   Future<List<dynamic>> getPlayerInvitations(String userId) async {
//     try {
//       final response = await _apiService.getGetApiResponse(
//         'https://okr-navigator-backend.onrender.com/challenges/invitations/$userId',
//       );
//       return response is List ? response : [];
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<dynamic> respondToChallenge(int challengeId, String playerId, bool accept) async {
//     try {
//       final request = ChallengeResponseRequest(
//         playerId: playerId,
//         accept: accept,
//       );
//
//       final response = await _apiService.getPatchApiResponse(
//         'https://okr-navigator-backend.onrender.com/invitation/$challengeId/respond',
//         request.toJson(),
//       );
//
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }