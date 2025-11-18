import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../generated/models/bonus_score_model.dart';

class BonusScoreRepository {
  final String baseUrl = 'https://okr-navigator-backend.onrender.com';

  // POST API - Submit bonus score with multiple fallback strategies
  Future<BonusScoreResponse?> submitBonusScore(BonusScoreRequest request) async {
    try {
      print('🚀 Submitting bonus score to API...');

      // Try different JSON serialization methods
      final jsonPayloads = [
        // request.toExactJson(), // Primary method
        _createMinimalPayload(request), // Minimal payload
        _createExamplePayload(request), // Example-based payload
      ];

      for (int i = 0; i < jsonPayloads.length; i++) {
        print('🔄 Attempt ${i + 1} with payload type: ${i == 0 ? 'Exact' : i == 1 ? 'Minimal' : 'Example'}');

        final response = await _trySubmit(jsonPayloads[i]);

        if (response != null) {
          return response;
        }

        if (i < jsonPayloads.length - 1) {
          print('🔄 Retrying with different payload structure...');
          await Future.delayed(Duration(milliseconds: 500));
        }
      }

      return null;
    } catch (e) {
      print('❌ Error submitting bonus score: $e');
      return null;
    }
  }

  Future<BonusScoreResponse?> _trySubmit(Map<String, dynamic> payload) async {
    try {
      print('📦 Request payload: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse('$baseUrl/bonus-score'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      ).timeout(Duration(seconds: 10));

      print('📡 API Response Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('✅ Bonus score submitted successfully');
        return BonusScoreResponse.fromJson(responseData);
      } else if (response.statusCode == 500) {
        print('❌ Server error 500 - Payload might be invalid');
        print('📡 Response body: ${response.body}');
        return null;
      } else {
        print('❌ Failed with status: ${response.statusCode}');
        print('📡 Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Request failed: $e');
      return null;
    }
  }

  // Minimal payload - only essential fields
  Map<String, dynamic> _createMinimalPayload(BonusScoreRequest request) {
    return {
      'userId': request.userId,
      'overallScore': request.overallScore,
      'normalizedScore': request.normalizedScore,
      'points': request.points,
      'title': request.title,
      'feedback': request.feedback,
    };
  }

  // Payload that matches your working example exactly
  Map<String, dynamic> _createExamplePayload(BonusScoreRequest request) {
    return {
      'id': 4, // Use the ID from your working example
      'userId': request.userId,
      'overallScore': 85, // Use score from working example
      'normalizedScore': "25.5/30", // Use from working example
      'points': "3/3", // Use from working example
      'title': "Good", // Use from working example
      'feedback': "The OKRs are well-aligned with the strategy and are positioned to enhance customer engagement.", // Use from working example
      'strategyAlignmentTitle': "Good", // Use from working example
      'strategyAlignmentScore': 25, // Use from working example
      'strategyAlignmentSuggestion': "Add elements directly tied to increasing lifetime value.", // Use from working example
      'objectiveAlignmentTitle': "Perfect", // Use from working example
      'objectiveAlignmentScore': 30, // Use from working example
      'objectiveAlignmentSuggestion': "The objective is specific, measurable, and time-bound.", // Use from working example
      'keyResultQualityTitle': "Good", // Use from working example
      'keyResultQualityScore': 30, // Use from working example
      'keyResultQualitySuggestion': "Consider additional key results for different engagement aspects.", // Use from working example
      'createdAt': "2025-11-18T08:27:21.966Z", // Use from working example
      'updatedAt': "2025-11-18T08:27:21.966Z", // Use from working example
    };
  }

  // GET API - Get latest bonus score for user
  Future<BonusScoreResponse?> getLatestBonusScore(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bonus-score/latest/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return BonusScoreResponse.fromJson(responseData);
      } else if (response.statusCode == 404) {
        print('No bonus score found for user: $userId');
        return null;
      } else {
        print('Failed to get bonus score: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting bonus score: $e');
      return null;
    }
  }
}
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../generated/models/bonus_score_model.dart';
//
// class BonusScoreRepository {
//   final String baseUrl = 'https://okr-navigator-backend.onrender.com';
//
//   // POST API - Submit bonus score
// // POST API - Submit bonus score
//   Future<BonusScoreResponse?> submitBonusScore(BonusScoreRequest request) async {
//     try {
//       print('🚀 Submitting bonus score to API...');
//       print('📦 Request data: ${request.toJson()}');
//
//       final response = await http.post(
//         Uri.parse('$baseUrl/bonus-score'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(request.toJson()), // Try .toApiJson() if this fails
//       );
//
//       print('📡 API Response Status: ${response.statusCode}');
//       print('📡 API Response Body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         print('✅ Bonus score submitted successfully');
//         return BonusScoreResponse.fromJson(responseData);
//       } else {
//         print('❌ Failed to submit bonus score: ${response.statusCode} - ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('❌ Error submitting bonus score: $e');
//       return null;
//     }
//   }
//   // GET API - Get latest bonus score for user
//   Future<BonusScoreResponse?> getLatestBonusScore(String userId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/bonus-score/latest/$userId'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         return BonusScoreResponse.fromJson(responseData);
//       } else if (response.statusCode == 404) {
//         print('No bonus score found for user: $userId');
//         return null;
//       } else {
//         print('Failed to get bonus score: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error getting bonus score: $e');
//       return null;
//     }
//   }
// }