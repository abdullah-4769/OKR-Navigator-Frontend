import 'package:game_app/data/network/network_api_services.dart';
import 'package:game_app/data/response/api_response.dart';
import '../../core/api_constants.dart';

class ShowChallengersVsRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<ApiResponse<List<dynamic>>> getChallengePlayers(String challengeId) async {
    try {
      print('🔵 Repository: Calling API for challengeId: $challengeId');

      // ✅ Use ApiConstants for the full URL
      final fullUrl = ApiConstants.getChallengePlayers(challengeId);
      print('🔵 Full URL: $fullUrl');

      final response = await _apiService.getGetApiResponse(fullUrl);

      print('🔵 Repository: Response type: ${response.runtimeType}');
      print('🔵 Repository: Response data: $response');

      // Validate response is a List
      if (response is! List) {
        throw Exception('Expected List but got ${response.runtimeType}');
      }

      print('✅ Successfully parsed ${response.length} players');

      return ApiResponse.completed(response as List<dynamic>);
    } catch (e) {
      print('❌ Repository error: $e');
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
