import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_constants.dart';
import '../../data/response/api_response.dart';

class ShowChallengersVsRepository {
  Future<ApiResponse<List<dynamic>>> getChallengePlayers(String challengeId) async {
    try {
      final url = '${ApiConstants.baseUrl}/challenges/$challengeId/challengeplayer';

      print('🔵 Repository: Calling API for challengeId: $challengeId');
      print('🔵 Full URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('🔵 Response Status: ${response.statusCode}');
      print('🔵 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data is List) {
          print('🔵 Repository: Response type: List<dynamic>');
          print('🔵 Repository: Found ${data.length} players');

          // ✅ FIXED: Just return the raw data, let ViewModel handle enrichment
          return ApiResponse.completed(data);
        } else {
          throw Exception('Unexpected response format: $data');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Repository Error: $e');
      return ApiResponse.error(e.toString());
    }
  }
}
//
//
// import 'package:game_app/data/network/network_api_services.dart';
// import 'package:game_app/data/response/api_response.dart';
//
// class ShowChallengersVsRepository {
//   final NetworkApiService _apiService = NetworkApiService();
//
//   Future<ApiResponse<List<dynamic>>> getChallengePlayers(String challengeId) async {
//     try {
//       print('🔵 Repository: Calling API for challengeId: $challengeId');
//
//       final response = await _apiService.getGetApiResponse(
//         '/challenges/$challengeId/challengeplayer',
//       );
//
//       print('🔵 Repository: Response type: ${response.runtimeType}');
//       print('🔵 Repository: Response data: $response');
//
//       // Check if response is HTML (error case)
//       if (response is String) {
//         if (response.contains('<!DOCTYPE html>') || response.contains('<html>')) {
//           throw Exception('Server returned HTML instead of JSON. Check your API endpoint.');
//         }
//       }
//
//       // Validate response is a List
//       if (response is! List) {
//         throw Exception('Expected List but got ${response.runtimeType}');
//       }
//
//       return ApiResponse.completed(response as List<dynamic>);
//     } catch (e) {
//       print('❌ Repository error: $e');
//       return ApiResponse.error(e.toString());
//     }
//   }
// }
//
//
//
// //
// // import 'package:game_app/data/network/network_api_services.dart';
// // import 'package:game_app/data/response/api_response.dart';
// //
// // import '../../services/key_results_service.dart';
// //
// // class ShowChallengersVsRepository {
// //   final NetworkApiService _apiService = NetworkApiService();
// //
// //   Future<ApiResponse<dynamic>> getChallengePlayers(String challengeId) async {
// //     try {
// //       final response = await _apiService.getGetApiResponse(
// //         '/challenges/$challengeId/challengeplayer',
// //       );
// //       if (response is Map && response.containsKey('doctype')) {
// //         throw Exception('Invalid API response: received HTML');
// //       }
// //       return ApiResponse.completed(response);
// //     } catch (e) {
// //       return ApiResponse.error(e.toString());
// //     }
// //   }
// // }
