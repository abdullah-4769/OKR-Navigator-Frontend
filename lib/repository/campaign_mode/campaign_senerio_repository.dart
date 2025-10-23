import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/shared_preference.dart';

class NavigatorCertificationRepository {
  final String baseUrl = 'http://192.168.1.3:3000';

  Future<Map<String, dynamic>> fetchAiScenarioStrategies() async {
    try {
      // ✅ Get saved role & organization (sector) from SharedPrefs
      final role = SharedPrefs.getUserRole() ?? 'CEO'; // Default to CEO if not found
      final organization = SharedPrefs.getMissionDescription() ?? 'EcoTech Innovations is a startup dedicated to designing sustainable technology solutions for urban environments';

      final url = Uri.parse('$baseUrl/campaign/certification/ai-scenario-strategy/generate');
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






// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// //
// // class NavigatorCertificationRepository {
// //   final String baseUrl = 'http://192.168.1.3:3000';
// //
// //   Future<Map<String, dynamic>> fetchStrategies() async {
// //     final role = 'Navigator';
// //     final organization = 'TechCorp';
// //     final url = Uri.parse('$baseUrl/navigator-certification?role=$role&organization=$organization');
// //
// //     print('🌐 [Repository] Calling API: $url');
// //
// //     final response = await http.get(url);
// //     print('📩 [Repository] Response status: ${response.statusCode}');
// //     print('📦 [Repository] Raw response body: ${response.body}');
// //
// //     if (response.statusCode == 200 || response.statusCode == 201) {
// //       final data = jsonDecode(response.body);
// //       print('✅ [Repository] Strategies found: ${(data['strategies'] ?? []).length}');
// //       return data;
// //     } else {
// //       throw Exception('Failed to load strategies');
// //     }
// //   }
// // }
// //
//
//
//
//
//
//
//
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../services/shared_preference.dart';
//
// class NavigatorCertificationRepository {
//   final String baseUrl = 'http://192.168.1.3:3000'; // same network as your backend
//
//   Future<List<dynamic>> fetchStrategies() async {
//     try {
//       // ✅ Get saved role & organization (sector) from SharedPrefs
//       final role = SharedPrefs.getUserRole() ?? 'defaultRole';
//       final organization = SharedPrefs.getMissionDescription() ?? 'defaultOrg';
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
//         if (data is Map && data.containsKey('strategies')) {
//           print('✅ [Repository] Strategies found: ${data['strategies'].length}');
//           return data['strategies'];
//         } else if (data is List) {
//           print('✅ [Repository] Received list directly: ${data.length}');
//           return data;
//         } else {
//           print('⚠️ [Repository] Unexpected structure: $data');
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
