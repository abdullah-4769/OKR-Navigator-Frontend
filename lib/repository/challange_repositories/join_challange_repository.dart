// import 'dart:convert';
// import '../../core/api_constants.dart';
// import '../../data/network/base_api_services.dart';
// import '../../data/network/network_api_services.dart';
// import '../../generated/models/requests/challange_mode/join_challange_request.dart';
//
//
// class JoinChallengeRepository {
//   final BaseApiServices _apiServices = NetworkApiService();
//
//   Future<dynamic> joinChallenge(String code, JoinChallengeRequest request) async {
//     try {
//       final url = ApiConstants.joinChallenge(code);
//       print('JoinChallengeRepository: Sending POST to $url with data: ${jsonEncode(request.toJson())}');
//       final response = await _apiServices.getPostApiResponse(url, request.toJson());
//       print('JoinChallengeRepository: Received response: $response');
//       return response;
//     } catch (e) {
//       print('JoinChallengeRepository: Error during API call: $e');
//       rethrow;
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/api_constants.dart';
import '../../generated/models/requests/challange_mode/join_challange_request.dart';

class JoinChallengeRepository {
  // ✅ Join challenge using invite code
  Future<Map<String, dynamic>> joinChallenge(String code, String playerId) async {
    try {
      if (kDebugMode) {
        print('🌐 JOIN CHALLENGE API REQUEST:');
        print('  - URL: ${ApiConstants.baseUrl}/challenges/join');
        print('  - Invite Code: $code');
        print('  - Player ID: $playerId');
      }

      final url = Uri.parse(ApiConstants.joinChallenge(code));

      final body = {
        'code': code.toUpperCase(),
        'playerId': playerId,
      };

      if (kDebugMode) print('  - Body: ${jsonEncode(body)}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (kDebugMode) {
        print('📥 JOIN CHALLENGE API RESPONSE:');
        print('  - Status Code: ${response.statusCode}');
        print('  - Body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (kDebugMode) print('✅ Successfully joined challenge: $data');

        return data;
      } else if (response.statusCode == 404) {
        throw Exception('Challenge not found. Please check your invite code.');
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Bad request';
        throw Exception(errorMessage);
      } else if (response.statusCode == 409) {
        throw Exception('You have already joined this challenge.');
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to join challenge';
        throw Exception('HTTP ${response.statusCode}: $errorMessage');
      }
    } catch (e) {
      if (kDebugMode) print('❌ JOIN CHALLENGE ERROR: $e');
      rethrow;
    }
  }

  // ✅ Verify if challenge code exists (optional - for validation)
  Future<bool> verifyChallengeCode(String inviteCode) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/challenges/verify/$inviteCode');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (kDebugMode) {
        print('🔍 VERIFY CODE RESPONSE:');
        print('  - Status: ${response.statusCode}');
        print('  - Body: ${response.body}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print('❌ VERIFY CODE ERROR: $e');
      return false;
    }
  }
}






// import 'dart:convert';
//
// import '../../data/network/base_api_services.dart';
// import '../../data/network/network_api_services.dart';
// import '../../generated/models/requests/challange_mode/join_challange_request.dart';
//
// class JoinChallengeRepository {
//   final BaseApiServices _apiServices = NetworkApiService();
//
//   static const String baseUrl = 'http://192.168.43.101:3000';
//
//   Future<dynamic> joinChallenge(String code, JoinChallengeRequest request) async {
//     try {
//       final url = '$baseUrl/challenges/join/$code';
//       print('JoinChallengeRepository: Sending POST to $url with data: ${jsonEncode(request.toJson())}');
//       final response = await _apiServices.getPostApiResponse(url, request.toJson());
//       print('JoinChallengeRepository: Received response: $response');
//       return response;
//     } catch (e) {
//       print('JoinChallengeRepository: Error during API call: $e');
//       rethrow;
//     }
//   }
// }
//
//
//
//
//
//
//
//
//
// // import 'dart:convert';
// //
// // import '../../data/network/base_api_services.dart';
// // import '../../data/network/network_api_services.dart';
// // import '../../generated/models/requests/challange_mode/join_challange_request.dart';
// //
// //
// // class JoinChallengeRepository {
// //   final BaseApiServices _apiServices = NetworkApiService();
// //
// //   // Base URL
// //   static const String baseUrl = '
// //   http://192.168.1.8:3000';
// //
// //   Future<dynamic> joinChallenge(String code, JoinChallengeRequest request) async {
// //     try {
// //       final url = '$baseUrl/challenges/join/$code';
// //       final response = await _apiServices.getPostApiResponse(url, request.toJson());
// //       return response;
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// // }
