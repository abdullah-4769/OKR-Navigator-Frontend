import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../services/shared_preference.dart';
import '../../core/api_constants.dart';
import '../../generated/models/responses/campaign/certification_info_mode.dart';

class CertificationInfoApiService extends GetxService {
  final String baseUrl = ApiConstants.baseUrl;

  // Fallback user ID
  static const String fallbackUserId = 'f40e85cb-a4b9-4053-bae2-506bae93f5d1';

  Future<CertificationInfoResponse> getCertificationInfo() async {
    try {
      // Try to get user ID from SharedPreferences first
      String? userId = SharedPrefs.getUserId();

      // Fallback to hardcoded ID if null
      if (userId == null) {
        userId = fallbackUserId;
        print('⚠️ User ID not found in SharedPreferences, using fallback ID: $userId');
      } else {
        print('✅ Using user ID from SharedPreferences: $userId');
      }

      final url = Uri.parse('$baseUrl/campaign-award/certific-info/$userId');

      print('🚀 Fetching certification info from: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return CertificationInfoResponse.fromJson(responseData);
      } else if (response.statusCode == 404) {
        // Return empty data if no certifications found
        return CertificationInfoResponse(
          progress: ProgressInfo(earned: 0, total: 12, inProgress: 0),
          certifications: [],
        );
      } else {
        throw Exception(
            'Failed to fetch certification info: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error in getCertificationInfo: $e');
      rethrow;
    }
  }
}
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
//
// import '../../../services/shared_preference.dart';
// import '../../core/api_constants.dart';
// import '../../generated/models/responses/campaign/certification_info_mode.dart';
//
// class CertificationInfoApiService extends GetxService {
//   final String baseUrl = ApiConstants.baseUrl;
//
//   Future<CertificationInfoResponse> getCertificationInfo() async {
//     try {
//       final userId = SharedPrefs.getUserId();
//       if (userId == null) {
//         throw Exception('User ID not found. Please login again.');
//       }
//
//       final url = Uri.parse('$baseUrl/campaign-award/certific-info/$userId');
//
//       print('🚀 Fetching certification info from: $url');
//
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
//
//       print('📥 Response status: ${response.statusCode}');
//       print('📥 Response body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         return CertificationInfoResponse.fromJson(responseData);
//       } else if (response.statusCode == 404) {
//         // Return empty data if no certifications found
//         return CertificationInfoResponse(
//           progress: ProgressInfo(earned: 0, total: 12, inProgress: 0),
//           certifications: [],
//         );
//       } else {
//         throw Exception(
//             'Failed to fetch certification info: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('❌ Error in getCertificationInfo: $e');
//       rethrow;
//     }
//   }
// }