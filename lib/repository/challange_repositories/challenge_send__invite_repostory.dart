import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/api_constants.dart';

class ChallengeSendInviteRepository {
  Future<List<dynamic>> sendInvites(dynamic challengeId, List<String> playerIds) async {
    try {
      // Convert challengeId to string for the URL
      final String challengeIdStr = challengeId.toString();
      final url = Uri.parse('${ApiConstants.baseUrl}/challenges/$challengeIdStr/send-multiple-invites');

      if (kDebugMode) print("🎯 Sending invites to $playerIds for challenge $challengeIdStr");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'playerIds': playerIds}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (kDebugMode) print("✅ Invite sent successfully: $data");
        return data;
      } else {
        if (kDebugMode) print("❌ Error sending invite: ${response.statusCode} - ${response.body}");
        throw Exception('Failed to send invites: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print("❌ Exception sending invite: $e");
      rethrow;
    }
  }
}



// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import '../../core/api_constants.dart';
//
//
// class ChallengeSendInviteRepository {
//   Future<List<dynamic>> sendInvites(dynamic challengeId, List<String> playerIds) async {
//     // Convert challengeId to string for the URL
//     final String challengeIdStr = challengeId.toString();
//     final url = Uri.parse('${ApiConstants.baseUrl}/challenges/$challengeIdStr/send-multiple-invites');
//
//     if (kDebugMode) print("Sending invites to $playerIds for challenge $challengeIdStr");
//
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'playerIds': playerIds}),
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       if (kDebugMode) print("Invite sent successfully: $data");
//       return data;
//     } else {
//       if (kDebugMode) print("Error sending invite: ${response.body}");
//       throw Exception('Failed to send invites');
//     }
//   }
// }
//
//
//
