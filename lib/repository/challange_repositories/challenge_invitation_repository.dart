import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_constants.dart';


class ChallengeRepository {
  Future<Map<String, dynamic>> createChallenge(String hostId) async {
    final response = await http.post(
      Uri.parse(ApiConstants.getUrl(ApiConstants.challenges)),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'hostId': hostId}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create challenge: ${response.body}');
    }
  }
}