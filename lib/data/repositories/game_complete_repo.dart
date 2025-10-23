// lib/data/repositories/game_complete_repository.dart

import 'dart:convert';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../generated/models/responses/game_complete_model/game_complete_model.dart';
import '../datasources/complete_game_api.dart';

import '../../generated/network.dart';
import '../network/network_api_services.dart';

// class GameCompleteRepository {
//   final GameCompleteApi _gameCompleteApi = GameCompleteApi(dio);
//   //
//
//
// // lib/data/repositories/game_complete_repository.dart
//   Future<GameCompleteModel> getLatestGameScore(String userId) async {
//     try {
//       final response = await _gameCompleteApi.getLatestGameScore(userId);
//
//       // ✅ FIXED: Check if response has valid data
//       if (response.id == null && response.score == null) {
//         // Create a default response if no data found
//         return GameCompleteModel(
//           id: 0,
//           userId: userId,
//           score: 0,
//           scor: "No game data found",
//           badge: "Participant",
//           trophy: "",
//           totalPoints: "0/10",
//           breakdown: Breakdown(
//             alignmentStrategy: "0/2",
//             objectiveClarity: "0/2",
//             keyresultQuality: "0/2",
//             initiativeRelevance: "0/2",
//             challengeAdoption: "0/2",
//           ),
//         );
//       }
//
//       return response;
//     } catch (e) {
//       print('❌ Repository error: $e');
//       // Return default data on error
//       return GameCompleteModel(
//         id: 0,
//         userId: userId,
//         score: 0,
//         scor: "Error loading data",
//         badge: "Participant",
//         trophy: "",
//         totalPoints: "0/10",
//         breakdown: Breakdown(
//           alignmentStrategy: "0/2",
//           objectiveClarity: "0/2",
//           keyresultQuality: "0/2",
//           initiativeRelevance: "0/2",
//           challengeAdoption: "0/2",
//         ),
//       );
//     }
//   }
//
//   // Future<GameCompleteModel> getLatestGameScore(String userId) async {
//   //   try {
//   //     final response = await _gameCompleteApi.getLatestGameScore(userId);
//   //
//   //     if (response.id == null) {
//   //       throw Exception('Failed to load game score');
//   //     }
//   //
//   //     return response;
//   //   } catch (e) {
//   //     throw Exception('Failed to fetch game completion data: $e');
//   //   }
//   // }
// }// lib/repository/game_complete_repository.dart
class GameCompleteRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<dynamic> getLatestGameScore(String userId) async {
    try {
      final response = await _apiService.getGetApiResponse(
        'http://192.168.1.3:3000/solo-score/user/$userId/latest',
      );

      // ✅ FIXED: Handle empty or invalid responses
      if (response == null) {
        throw Exception('No data received from server');
      }

      // If response is a string, try to parse it
      if (response is String) {
        if (response.isEmpty) {
          throw Exception('Empty response from server');
        }
        try {
          return jsonDecode(response);
        } catch (e) {
          throw Exception('Failed to parse JSON: $e');
        }
      }

      // If response is already a Map, return it directly
      if (response is Map<String, dynamic>) {
        return response;
      }

      throw Exception('Unexpected response format: ${response.runtimeType}');

    } catch (e) {
      print('❌ Repository error: $e');
      rethrow;
    }
  }
}
