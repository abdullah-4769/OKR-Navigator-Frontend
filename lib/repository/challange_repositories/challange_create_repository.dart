import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_constants.dart';


class ChallengeRepository {
  Future<Map<String, dynamic>> createChallenge(String hostId) async {
    final response = await http.post(
      Uri.parse(ApiConstants.getUrl(ApiConstants.challenges)),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hostId': hostId}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create challenge: ${response.body}');
    }
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class ChallengeRepository {
//   final String baseUrl = "http://192.168.43.101:3000";
//
//   Future<Map<String, dynamic>> createChallenge(String hostId) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/challenges'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'hostId': hostId}),
//     );
//
//     if (response.statusCode == 201 || response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to create challenge: ${response.body}');
//     }
//   }
// }
//
//
//
//
//
//
// // import '../../data/network/network_api_services.dart';
// // import '../../generated/models/requests/challange_mode/challange_create_request.dart';
// // import 'package:flutter/foundation.dart';
// // import '../../generated/models/responses/create_challange_response.dart';
// //
// // class ChallengeRepository {
// //   final NetworkApiService _apiService = NetworkApiService();
// //
// //   Future<String> createChallenge(String hostId) async {
// //     try {
// //       final request = ChallengeCreateRequest(hostId: hostId);
// //
// //       final response = await _apiService.getPostApiResponse(
// //         'http://192.168.1.5:3000/challenges',
// //         request.toJson(),
// //       );
// //
// //       // Parse the response using the response model
// //       final challengeResponse = ChallengeCreateResponse.fromJson(response);
// //
// //       return challengeResponse.code;
// //     } catch (e) {
// //       if (kDebugMode) {
// //         print("Repository error: $e");
// //       }
// //       rethrow;
// //     }
// //   }
// // }