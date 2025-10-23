import '../../data/network/network_api_services.dart';

class ChallengeModeScoreRepository {
  final NetworkApiService _apiService = NetworkApiService();

  /// Fetch challenge score with fallback to mock data
  Future<dynamic> fetchChallengeScore({
    required String challengeId,
    required String userId,
  }) async {
    try {
      // Try with 'challenge' parameter (matching your original API spec)
      final url = '/challenge-mode-score?challenge=$challengeId&userId=$userId';

      print('🌐 Attempting API call: $url');

      final response = await _apiService.getGetApiResponse(url);

      // Check if response is HTML (endpoint doesn't exist)
      if (response is String) {
        if (response.contains('<!DOCTYPE html>') || response.contains('<html')) {
          print('❌ API endpoint does not exist - returning null for mock data fallback');
          return null; // Will trigger mock data in ViewModel
        }
      }

      print('✅ API call successful');
      return response;
    } catch (e) {
      print('❌ API call failed: $e');
      // Return null to trigger mock data fallback
      return null;
    }
  }

  /// Try alternative API endpoints
  Future<dynamic> tryAlternativeEndpoints({
    required String challengeId,
    required String userId,
  }) async {
    final endpoints = [
      '/challenge-mode-score?challenge=$challengeId&userId=$userId',
      '/challenge-mode-score?challengeId=$challengeId&userId=$userId',
      '/api/challenge-score?challenge=$challengeId&userId=$userId',
      '/challenges/$challengeId/scores?userId=$userId',
      '/challenge/$challengeId/results?userId=$userId',
    ];

    for (final endpoint in endpoints) {
      try {
        print('🔄 Trying endpoint: $endpoint');
        final response = await _apiService.getGetApiResponse(endpoint);

        if (response != null &&
            response is! String &&
            !response.toString().contains('<!DOCTYPE html>')) {
          print('✅ Success with endpoint: $endpoint');
          return response;
        }
      } catch (e) {
        print('❌ Failed: $endpoint - $e');
        continue;
      }
    }

    print('❌ All endpoints failed - using mock data');
    return null;
  }
}
// import '../../data/network/network_api_services.dart';
//
// class ChallengeModeScoreRepository {
//   final NetworkApiService _apiService = NetworkApiService();
//
//   /// Fetch challenge score with proper error handling
//   Future<dynamic> fetchChallengeScore({
//     required String challengeId,
//     required String userId,
//   }) async {
//     try {
//       // Try the correct endpoint format based on your API
//       // Your API expects: ?challenge=5&userId=user123
//       final url = '/challenge-mode-score?challenge=$challengeId&userId=$userId';
//
//       print('🌐 Fetching from URL: $url');
//       print('   Challenge ID: $challengeId');
//       print('   User ID: $userId');
//
//       final response = await _apiService.getGetApiResponse(url);
//
//       print('📦 Response type: ${response.runtimeType}');
//
//       // Check if response is HTML (wrong endpoint)
//       if (response is String && response.contains('<!DOCTYPE html>')) {
//         print('❌ Received HTML response - endpoint may not exist');
//         return null;
//       }
//
//       print('✅ API call successful');
//       return response;
//     } catch (e, stackTrace) {
//       print('❌ API call failed: $e');
//       print('Stack trace: $stackTrace');
//       rethrow;
//     }
//   }
//
//   /// Test API connection
//   Future<bool> testApiConnection() async {
//     try {
//       final testUrl = '/challenge-mode-score?challenge=test&userId=test';
//       print('🔍 Testing API connection: $testUrl');
//
//       final response = await _apiService.getGetApiResponse(testUrl);
//
//       if (response is String && response.contains('<!DOCTYPE html>')) {
//         print('❌ API returned HTML - endpoint may not exist');
//         return false;
//       }
//
//       print('✅ API connection test passed');
//       return true;
//     } catch (e) {
//       print('❌ API connection test failed: $e');
//       return false;
//     }
//   }
// }
//
