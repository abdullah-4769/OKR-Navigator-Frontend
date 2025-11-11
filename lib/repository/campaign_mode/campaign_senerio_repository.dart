import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_constants.dart';
import '../../services/shared_preference.dart';


class NavigatorCertificationRepository {
  Future<Map<String, dynamic>> fetchAiScenarioStrategies() async {
    try {
      // ✅ Get saved role & organization (sector) from SharedPrefs
      final role = SharedPrefs.getUserRole() ?? 'CEO';
      final organization = SharedPrefs.getMissionDescription() ??
          'EcoTech Innovations is a startup dedicated to designing sustainable technology solutions for urban environments';

      final url = Uri.parse(ApiConstants.AI_SCENARIO_STRATEGY_ENDPOINT);

      print('🌍 [Repository] Sending POST request to: $url');
      print('📤 [Repository] Body => { "role": "$role", "sector": "$organization" }');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'role': role,
          'sector': organization,
        }),
      );

      print('📩 [Repository] Response status: ${response.statusCode}');
      print('📦 [Repository] Raw response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic>) {
          print('✅ [Repository] Scenario & Strategies found');
          print('📖 Scenario: ${data['scenario']}');
          print('🎯 Strategies count: ${(data['strategies'] ?? []).length}');
          print('🔑 Correct strategy ID: ${data['correct_strategy_id']}');

          return data;
        } else {
          print('⚠️ [Repository] Unexpected response format: $data');
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load strategies (status: ${response.statusCode})');
      }
    } catch (e, stack) {
      print('💥 [Repository] Exception: $e');
      print('🧱 Stack trace:\n$stack');
      rethrow;
    }
  }
}






// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../services/shared_preference.dart';
//
// class NavigatorCertificationRepository {
//   final String baseUrl = 'http://192.168.1.3:3000';
//
//   Future<Map<String, dynamic>> fetchAiScenarioStrategies() async {
//     try {
//       // ✅ Get saved role & organization (sector) from SharedPrefs
//       final role = SharedPrefs.getUserRole() ?? 'CEO'; // Default to CEO if not found
//       final organization = SharedPrefs.getMissionDescription() ?? 'EcoTech Innovations is a startup dedicated to designing sustainable technology solutions for urban environments';
//
//       final url = Uri.parse('$baseUrl/campaign/certification/ai-scenario-strategy/generate');
//       print('🌍 [Repository] Sending POST request to: $url');
//       print('📤 [Repository] Body => { "role": "$role", "sector": "$organization" }');
//
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'role': role,
//           'sector': organization,
//         }),
//       );
//
//       print('📩 [Repository] Response status: ${response.statusCode}');
//       print('📦 [Repository] Raw response body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//
//         if (data is Map<String, dynamic>) {
//           print('✅ [Repository] Scenario & Strategies found');
//           print('📖 Scenario: ${data['scenario']}');
//           print('🎯 Strategies count: ${(data['strategies'] ?? []).length}');
//           print('🔑 Correct strategy ID: ${data['correct_strategy_id']}');
//
//           return data;
//         } else {
//           print('⚠️ [Repository] Unexpected response format: $data');
//           throw Exception('Unexpected response format');
//         }
//       } else {
//         throw Exception('Failed to load strategies (status: ${response.statusCode})');
//       }
//     } catch (e, stack) {
//       print('💥 [Repository] Exception: $e');
//       print('🧱 Stack trace:\n$stack');
//       rethrow;
//     }
//   }
// }
//
//
//
//
