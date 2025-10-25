import 'dart:convert';
import 'package:http/http.dart' as http;

import '../generated/models/responses/key_results_model/key_results_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.6:3000';

  Future<KeyResultModel> fetchKeyResults({
    String? strategy,
    String? objective,
    String? role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/key-result/batch'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'strategy': strategy ?? '',
          'objective': objective ?? '',
          'role': role ?? '',
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return KeyResultModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load key results: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching key results: $e');
    }
  }
}
