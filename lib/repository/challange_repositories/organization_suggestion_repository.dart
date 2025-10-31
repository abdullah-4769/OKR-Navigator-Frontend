import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_constants.dart';


class CampaignSuggestionRepository {
  Future<Map<String, dynamic>?> postRoleAndLanguage(String role, String language) async {
    try {
      print("Making API call to: ${ApiConstants.getUrl(ApiConstants.campaignSuggestion)}");
      print("With data: role=$role, language=$language");

      final url = Uri.parse(ApiConstants.getUrl(ApiConstants.campaignSuggestion));
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'role': role,
          'language': language,
        }),
      );

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body);
        print("API Success: $result");
        return result;
      } else {
        print('Failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error posting role: $e');
      return null;
    }
  }
}








// // In your repository, add debug prints:
// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// class CampaignSuggestionRepository {
//   Future<Map<String, dynamic>?> postRoleAndLanguage(String role, String language) async {
//     try {
//       print("Making API call to: http://localhost:3000/campaign/ai/suggestion/organization/generate");
//       print("With data: role=$role, language=$language");
//
//       final url = Uri.parse('http://192.168.43.101:3000/campaign/ai/suggestion/organization/generate');
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'role': role,
//           'language': language,
//         }),
//       );
//
//       print("API Response Status: ${response.statusCode}");
//       print("API Response Body: ${response.body}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final result = jsonDecode(response.body);
//         print("API Success: $result");
//         return result;
//       } else {
//         print('Failed with status: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error posting role: $e');
//       return null;
//     }
//   }
// }