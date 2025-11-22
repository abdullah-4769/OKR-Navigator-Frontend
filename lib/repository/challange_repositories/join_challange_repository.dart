import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_constants.dart';

class JoinChallengeRepository {
  /// Join a challenge using an invite code
  Future<Map<String, dynamic>> joinChallenge(String code, String userId) async {
    try {
      if (kDebugMode) {
        print('\n🌐 ========== JOIN CHALLENGE API REQUEST ==========');
        print('  📋 Invite Code: $code');
        print('  👤 User ID: $userId');
      }

      // ✅ CORRECT: Use the endpoint structure
      final url = Uri.parse('${ApiConstants.baseUrl}/challenges/join/$code');

      // ✅ CORRECT: Send userId in request body
      final body = jsonEncode({'userId': userId});

      if (kDebugMode) {
        print('  📡 URL: POST $url');
        print('  📦 Body: $body');
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (kDebugMode) {
        print('\n📥 API RESPONSE:');
        print('  ✓ Status Code: ${response.statusCode}');
        print('  ✓ Body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // ✅ CRITICAL: Extract challenge ID correctly
        final challengeId = data['challengeId'] ?? data['id'];

        if (challengeId == null) {
          throw Exception('No challenge ID in response');
        }

        if (kDebugMode) print('✅ Successfully joined challenge ID: $challengeId');

        // ✅ CRITICAL: Save to SharedPreferences with proper keys
        final prefs = await SharedPreferences.getInstance();

        // Clear old challenge IDs
        await prefs.remove('challengeId');
        await prefs.remove('acceptInviteChallengeId');

        // Save new challenge ID with BOTH keys for compatibility
        await prefs.setString('joinChallengeId', challengeId.toString());
        await prefs.setString('challengeId', challengeId.toString());

        if (kDebugMode) {
          print('💾 Saved Challenge IDs:');
          print('   - joinChallengeId: $challengeId');
          print('   - challengeId: $challengeId');
          print('==================================================\n');
        }

        return {
          'success': true,
          'challengeId': challengeId,
          'userId': userId,
          'message': data['message'] ?? 'Successfully joined challenge',
          'challenge': data,
        };
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

  /// Get challenge details by ID
  Future<Map<String, dynamic>> getChallengeDetails(int challengeId) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/challenges/$challengeId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get challenge details');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error getting challenge details: $e');
      rethrow;
    }
  }
}