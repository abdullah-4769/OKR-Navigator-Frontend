// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import '../../../../data/api_urls.dart';
// import '../../../../data/app_exceptions.dart';
//
// class ChallengeInviteRepository {
//   final String baseUrl = AppUrls.baseUrl;
//
//   Future<List<dynamic>> sendChallengeInvite({
//     required int challengeId,
//     required List<String> playerIds,
//   }) async {
//     try {
//       final url = Uri.parse('$baseUrl/challenges/$challengeId/send-multiple-invites');
//
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'playerIds': playerIds}),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return jsonDecode(response.body) as List<dynamic>;
//       } else {
//         throw FetchDataException('Failed to send challenge invite');
//       }
//     } catch (e) {
//       throw FetchDataException(e.toString());
//     }
//   }
// }
