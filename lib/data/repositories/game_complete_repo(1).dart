import 'dart:convert';
import '../../core/api_constants.dart';
import '../network/network_api_services.dart';

class GameCompleteRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<dynamic> getLatestGameScore(String userId) async {
    try {
      print('🌐 [Repository] Making API call for user: $userId');

      final url = ApiConstants.getLatestGameScore(userId);
      print('🔗 [Repository] Full URL: $url');

      final response = await _apiService.getGetApiResponse(url);

      print('📨 [Repository] Response received: ${response != null ? 'YES' : 'NULL'}');

      if (response == null) {
        throw Exception('No response from server - possible network issue or invalid endpoint');
      }

      // Log the actual response for debugging
      print('📋 [Repository] Response Details:');
      print('   Type: ${response.runtimeType}');

      if (response is String) {
        print('   String Length: ${response.length}');
        print('   Content: $response');

        if (response.isEmpty) {
          throw Exception('Empty response body from API');
        }

        // Try to parse string as JSON
        if (response.trim().startsWith('{') || response.trim().startsWith('[')) {
          final parsed = jsonDecode(response);
          print('   Parsed JSON: $parsed');
          return parsed;
        } else {
          throw Exception('Response is not valid JSON: $response');
        }
      }

      // Handle map response
      if (response is Map<String, dynamic>) {
        print('   Keys: ${response.keys.toList()}');
        print('   Values: ${response.values.toList()}');

        // Check if it's just a success response without data
        if (response.containsKey('success') && response.length == 1) {
          print('⚠️ [Repository] API returned only success flag - no actual game data');
          throw Exception('No game score data available for this user. Please complete a game first.');
        }

        return response;
      }

      throw Exception('Unexpected response format: ${response.runtimeType}');

    } catch (e) {
      print('❌ [Repository] Error: $e');
      print('❌ [Repository] Error Type: ${e.runtimeType}');

      // Re-throw the error instead of returning mock data
      // This helps identify the actual API issue
      rethrow;

      // ONLY use mock data if you explicitly want to test the UI
      // Uncomment the line below to use mock data for testing:
      // return _createMockResponse();
    }
  }

  // Mock response for testing UI when API is not available
  Map<String, dynamic> _createMockResponse() {
    print('🛠 [Repository] Creating mock response for testing');
    return {
      "id": 1,
      "userId": "test-user-123",
      "score": 85,
      "scor": "Excellent strategic performance!",
      "totalPoints": "8/10",
      "badge": "Strategic Thinker",
      "trophy": "Silver Trophy",
      "breakdown": {
        "alignment-strategy": "2/2",
        "objective-clarity": "2/2",
        "keyresult-quality": "2/2",
        "initiative-relevance": "1/2",
        "challenge-adoption": "1/2"
      },
      "createdAt": "2025-10-29T10:00:00Z",
      "updatedAt": "2025-10-29T10:00:00Z"
    };
  }
}
