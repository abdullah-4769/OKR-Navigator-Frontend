// lib/data/services/evaluate_initiative_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../generated/models/responses/evaluate_initiative/evaluate_initiative_model.dart';

class EvaluateInitiativeService {
  final String baseUrl = 'http://192.168.1.4:3000';

  Future<EvaluateInitiativeModel> evaluateInitiatives({
    required String strategy,
    required String objective,
    required List<String> initiatives,
    required List<Map<String, dynamic>> keyResults,
    required String language,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/evaluate-initiatives');

    final body = {
      'strategy': strategy,
      'objective': objective,
      'initiatives': initiatives,
      'keyResults': keyResults,
      'language': language,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return EvaluateInitiativeModel.fromJson(
      jsonDecode(response.body),
    );
  }
}