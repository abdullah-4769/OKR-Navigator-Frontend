// lib/services/key_result/key_results.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../core/api_constants.dart';
import '../../generated/models/key_results/key_results.dart';

class KeyResultService extends GetxService {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<List<KeyResults>> getKeyResultsBatch() async {
    try {
      print('🔄 Service: Making API call...');

      final response = await http.post(
        Uri.parse('$baseUrl/key-result/batch'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "strategy": "Increase customer satisfaction in 2025",
          "objectives": [
            "Improve customer support response time",
            "Increase product reliability",
            "Enhance mobile app experience",
            "Expand self-service resources",
            "Boost customer loyalty program engagement",
            "Streamline onboarding for new customers",
            "Improve feedback collection",
            "Reduce support ticket backlog"
          ],
          "role": "Customer Success Manager",
          "language": "Spanish"
        }),
      );

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = json.decode(response.body);

        print('📦 Received ${responseData.length} objectives from API');

        // 🔹 Flatten all KeyResults from all objectives
        List<KeyResults> allKeyResults = [];

        for (var objectiveData in responseData) {
          final keyResult = KeyResult.fromJson(objectiveData);

          if (keyResult.keyResults != null && keyResult.keyResults!.isNotEmpty) {
            print('   Processing: ${keyResult.objective} (${keyResult.keyResults!.length} KRs)');
            allKeyResults.addAll(keyResult.keyResults!);
          }
        }

        print('✅ Total flattened KeyResults: ${allKeyResults.length}');

        if (allKeyResults.isEmpty) {
          print('⚠️ WARNING: No key results found!');
        } else {
          print('📋 Sample KRs:');
          for (int i = 0; i < 3 && i < allKeyResults.length; i++) {
            print('   ${i + 1}. ${allKeyResults[i].title} (ID: ${allKeyResults[i].id})');
          }
        }

        return allKeyResults;
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('❌ Service Error: $e');
      print('Stack: $stackTrace');
      throw Exception('Failed to load key results: $e');
    }
  }
}