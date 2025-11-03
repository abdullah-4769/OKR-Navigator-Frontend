import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../generated/models/requests/key_results_latest_model.dart';

class KeyResultsLatestRepository {
  // Set to false to use real API
  static const bool useMockData = false;

  // Update with your actual API base URL
  static const String baseUrl = 'https://okr-navigator-backend.onrender.com'; // Replace with your actual API URL

  // Method to create request
  KeyResultsLatestRequest createRequest({
    required String strategy,
    required List<String> objectives,
    required String role,
    required String language,
  }) {
    return KeyResultsLatestRequest(
      strategy: strategy,
      objectives: objectives,
      role: role,
      language: language,
    );
  }

  // Main method to generate key results batch - REAL API CALL
  Future<List<KeyResultsLatestResponse>> generateKeyResultsBatch({
    required String strategy,
    required List<String> objectives,
    required String role,
    required String language,
  }) async {
    if (useMockData) {
      print('🔧 Using mock data for key results generation');
      return await generateMockKeyResults(
        strategy: strategy,
        objectives: objectives,
        role: role,
        language: language,
      );
    }

    try {
      print('🚀 Making real API call to generate key results...');
      print('📋 Strategy: $strategy');
      print('🎯 Original Objectives: $objectives');
      print('👤 Role: $role');
      print('🌐 Language: $language');

      // ✅ FIX: Ensure we have exactly 8 objectives as required by API
      final List<String> adjustedObjectives = _adjustObjectivesForAPI(objectives);
      print('🎯 Adjusted Objectives for API: $adjustedObjectives');

      final request = createRequest(
        strategy: strategy,
        objectives: adjustedObjectives,
        role: role,
        language: language,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/key-result/batch'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      print('📡 API Response Status: ${response.statusCode}');
      print('📡 API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = json.decode(response.body);
        print('✅ API Success: Received ${responseData.length} objectives');

        // ✅ REMOVED FILTERING: Show ALL responses with ALL key results
        print('✅ Showing ALL ${responseData.length} objectives with all key results');

        final results = responseData
            .map((item) => KeyResultsLatestResponse.fromJson(item))
            .toList();

        // Calculate total key results
        final totalKeyResults = results.fold(0, (sum, response) => sum + response.keyResults.length);
        print('✅ Parsed ${results.length} objectives with total $totalKeyResults key results');
        return results;
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to generate key results: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Exception: $e');
      // Fallback to mock data if API fails
      print('🔄 Falling back to mock data due to API error');
      return await generateMockKeyResults(
        strategy: strategy,
        objectives: objectives,
        role: role,
        language: language,
      );
    }
  }

  // ✅ Adjust objectives to meet API requirement of exactly 8
  List<String> _adjustObjectivesForAPI(List<String> originalObjectives) {
    if (originalObjectives.length >= 8) {
      // If we have 8 or more, take the first 8
      return originalObjectives.take(8).toList();
    } else {
      // If we have less than 8, duplicate the first objective to reach 8
      final List<String> adjusted = List.from(originalObjectives);
      final String firstObjective = originalObjectives.first;

      while (adjusted.length < 8) {
        adjusted.add('$firstObjective (${adjusted.length + 1})');
      }

      return adjusted;
    }
  }

  // ✅ REMOVED: _filterResponsesForOriginalObjective method - we don't need filtering anymore

  // Alias method for compatibility
  Future<List<KeyResultsLatestResponse>> generateKeyResults({
    required String strategy,
    required List<String> objectives,
    required String role,
    required String language,
  }) async {
    return generateKeyResultsBatch(
      strategy: strategy,
      objectives: objectives,
      role: role,
      language: language,
    );
  }

  // Mock data method (fallback) - Generate more key results
  Future<List<KeyResultsLatestResponse>> generateMockKeyResults({
    required String strategy,
    required List<String> objectives,
    required String role,
    required String language,
  }) async {
    print('🎭 Generating mock key results...');

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    final List<KeyResultsLatestResponse> mockResponse = [];

    for (final objective in objectives) {
      final keyResults = _generateMockKeyResultsForObjective(objective, language);
      mockResponse.add(
        KeyResultsLatestResponse(
          strategy: strategy,
          objective: objective,
          role: role,
          keyResults: keyResults,
        ),
      );
    }

    final totalKeyResults = mockResponse.fold(0, (sum, response) => sum + response.keyResults.length);
    print('✅ Generated ${mockResponse.length} objectives with total $totalKeyResults key results');
    return mockResponse;
  }

  List<KeyResultLatest> _generateMockKeyResultsForObjective(String objective, String language) {
    print('🎯 Generating key results for objective: $objective in $language');

    // Generate more comprehensive mock key results (5-7 per objective)
    if (language.toLowerCase() == 'spanish') {
      return [
        KeyResultLatest(
          id: 1,
          title: 'Aumentar satisfacción del empleado',
          description: 'Lograr una puntuación de satisfacción del empleado del 85% o superior en las encuestas trimestrales',
          tag1: 'Encuesta',
          tag2: 'Trimestral',
        ),
        KeyResultLatest(
          id: 2,
          title: 'Reducir tasa de rotación',
          description: 'Disminuir la tasa de rotación de empleados en un 20% respecto al año anterior',
          tag1: 'Retención',
          tag2: 'Anual',
        ),
        KeyResultLatest(
          id: 3,
          title: 'Mejorar participación en formación',
          description: 'Alcanzar una tasa de participación del 90% en programas de desarrollo profesional',
          tag1: 'Desarrollo',
          tag2: 'Mensual',
        ),
        KeyResultLatest(
          id: 4,
          title: 'Incrementar feedback regular',
          description: 'Implementar revisiones de desempeño mensuales para el 100% del personal',
          tag1: 'Feedback',
          tag2: 'Mensual',
        ),
        KeyResultLatest(
          id: 5,
          title: 'Fortalecer cultura organizacional',
          description: 'Realizar 4 eventos de team building por trimestre con participación del 80%',
          tag1: 'Cultura',
          tag2: 'Trimestral',
        ),
        KeyResultLatest(
          id: 6,
          title: 'Mejorar comunicación interna',
          description: 'Aumentar el engagement en plataformas de comunicación interna en un 40%',
          tag1: 'Comunicación',
          tag2: 'Mensual',
        ),
        KeyResultLatest(
          id: 7,
          title: 'Incrementar reconocimiento empleados',
          description: 'Implementar programa de reconocimiento entre pares con 70% de participación mensual',
          tag1: 'Reconocimiento',
          tag2: 'Mensual',
        ),
      ];
    } else {
      // English version - More comprehensive for HR objectives
      return [
        KeyResultLatest(
          id: 1,
          title: 'Increase employee satisfaction score',
          description: 'Achieve employee satisfaction score of 85% or higher in quarterly surveys',
          tag1: 'Survey',
          tag2: 'Quarterly',
        ),
        KeyResultLatest(
          id: 2,
          title: 'Reduce employee turnover rate',
          description: 'Decrease employee turnover rate by 20% compared to previous year',
          tag1: 'Retention',
          tag2: 'Annual',
        ),
        KeyResultLatest(
          id: 3,
          title: 'Improve training participation',
          description: 'Achieve 90% participation rate in professional development programs',
          tag1: 'Development',
          tag2: 'Monthly',
        ),
        KeyResultLatest(
          id: 4,
          title: 'Increase regular feedback',
          description: 'Implement monthly performance reviews for 100% of staff',
          tag1: 'Feedback',
          tag2: 'Monthly',
        ),
        KeyResultLatest(
          id: 5,
          title: 'Strengthen organizational culture',
          description: 'Conduct 4 team building events per quarter with 80% participation',
          tag1: 'Culture',
          tag2: 'Quarterly',
        ),
        KeyResultLatest(
          id: 6,
          title: 'Enhance internal communication',
          description: 'Increase internal communication platform engagement by 40%',
          tag1: 'Communication',
          tag2: 'Monthly',
        ),
        KeyResultLatest(
          id: 7,
          title: 'Boost employee recognition',
          description: 'Implement peer recognition program with 70% monthly participation',
          tag1: 'Recognition',
          tag2: 'Monthly',
        ),
      ];
    }
  }
}
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../generated/models/requests/key_results_latest_model.dart';
//
//
// class KeyResultsLatestRepository {
//   // Set to false to use real API
//   static const bool useMockData = false;
//
//   // Update with your actual API base URL
//   static const String baseUrl = 'http://54.145.244.15:3000'; // Replace with your actual API URL
//
//   // Method to create request
//   KeyResultsLatestRequest createRequest({
//     required String strategy,
//     required List<String> objectives,
//     required String role,
//     required String language,
//   }) {
//     return KeyResultsLatestRequest(
//       strategy: strategy,
//       objectives: objectives,
//       role: role,
//       language: language,
//     );
//   }
//
//   // Main method to generate key results batch - REAL API CALL
//   Future<List<KeyResultsLatestResponse>> generateKeyResultsBatch({
//     required String strategy,
//     required List<String> objectives,
//     required String role,
//     required String language,
//   }) async {
//     if (useMockData) {
//       print('🔧 Using mock data for key results generation');
//       return await generateMockKeyResults(
//         strategy: strategy,
//         objectives: objectives,
//         role: role,
//         language: language,
//       );
//     }
//
//     try {
//       print('🚀 Making real API call to generate key results...');
//       print('📋 Strategy: $strategy');
//       print('🎯 Original Objectives: $objectives');
//       print('👤 Role: $role');
//       print('🌐 Language: $language');
//
//       // ✅ FIX: Ensure we have exactly 8 objectives as required by API
//       final List<String> adjustedObjectives = _adjustObjectivesForAPI(objectives);
//       print('🎯 Adjusted Objectives for API: $adjustedObjectives');
//
//       final request = createRequest(
//         strategy: strategy,
//         objectives: adjustedObjectives,
//         role: role,
//         language: language,
//       );
//
//       final response = await http.post(
//         Uri.parse('$baseUrl/key-result/batch'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(request.toJson()),
//       );
//
//       print('📡 API Response Status: ${response.statusCode}');
//       print('📡 API Response Body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final List<dynamic> responseData = json.decode(response.body);
//         print('✅ API Success: Received ${responseData.length} objectives');
//
//         // ✅ Filter responses to only include our original objective
//         final filteredResponses = _filterResponsesForOriginalObjective(responseData, objectives.first);
//
//         print('✅ Filtered to ${filteredResponses.length} relevant objectives');
//
//         final results = filteredResponses
//             .map((item) => KeyResultsLatestResponse.fromJson(item))
//             .toList();
//
//         print('✅ Parsed ${results.length} objectives with total ${results.fold(0, (sum, response) => sum + response.keyResults.length)} key results');
//         return results;
//       } else {
//         print('❌ API Error: ${response.statusCode} - ${response.body}');
//         throw Exception('Failed to generate key results: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ API Exception: $e');
//       // Fallback to mock data if API fails
//       print('🔄 Falling back to mock data due to API error');
//       return await generateMockKeyResults(
//         strategy: strategy,
//         objectives: objectives,
//         role: role,
//         language: language,
//       );
//     }
//   }
//
//   // ✅ NEW: Adjust objectives to meet API requirement of exactly 8
//   List<String> _adjustObjectivesForAPI(List<String> originalObjectives) {
//     if (originalObjectives.length >= 8) {
//       // If we have 8 or more, take the first 8
//       return originalObjectives.take(8).toList();
//     } else {
//       // If we have less than 8, duplicate the first objective to reach 8
//       final List<String> adjusted = List.from(originalObjectives);
//       final String firstObjective = originalObjectives.first;
//
//       while (adjusted.length < 8) {
//         adjusted.add('$firstObjective (${adjusted.length + 1})');
//       }
//
//       return adjusted;
//     }
//   }
//
//   // ✅ NEW: Filter API responses to only include our original objective
//   List<dynamic> _filterResponsesForOriginalObjective(List<dynamic> responses, String originalObjective) {
//     return responses.where((response) {
//       final objective = response['objective']?.toString() ?? '';
//       // Include responses that match our original objective (ignoring duplicates)
//       return objective.contains(originalObjective) && !objective.contains('(');
//     }).toList();
//   }
//
//   // Alias method for compatibility
//   Future<List<KeyResultsLatestResponse>> generateKeyResults({
//     required String strategy,
//     required List<String> objectives,
//     required String role,
//     required String language,
//   }) async {
//     return generateKeyResultsBatch(
//       strategy: strategy,
//       objectives: objectives,
//       role: role,
//       language: language,
//     );
//   }
//
//   // Mock data method (fallback)
//   Future<List<KeyResultsLatestResponse>> generateMockKeyResults({
//     required String strategy,
//     required List<String> objectives,
//     required String role,
//     required String language,
//   }) async {
//     print('🎭 Generating mock key results...');
//
//     // Simulate API delay
//     await Future.delayed(const Duration(seconds: 1));
//
//     final List<KeyResultsLatestResponse> mockResponse = [];
//
//     for (final objective in objectives) {
//       final keyResults = _generateMockKeyResultsForObjective(objective, language);
//       mockResponse.add(
//         KeyResultsLatestResponse(
//           strategy: strategy,
//           objective: objective,
//           role: role,
//           keyResults: keyResults,
//         ),
//       );
//     }
//
//     print('✅ Generated ${mockResponse.length} objectives with total ${mockResponse.fold(0, (sum, response) => sum + response.keyResults.length)} key results');
//     return mockResponse;
//   }
//
//   List<KeyResultLatest> _generateMockKeyResultsForObjective(String objective, String language) {
//     print('🎯 Generating key results for objective: $objective in $language');
//
//     // Generate more comprehensive mock key results
//     if (language.toLowerCase() == 'spanish') {
//       return [
//         KeyResultLatest(
//           id: 1,
//           title: 'Aumentar satisfacción del empleado',
//           description: 'Lograr una puntuación de satisfacción del empleado del 85% o superior en las encuestas trimestrales',
//           tag1: 'Encuesta',
//           tag2: 'Trimestral',
//         ),
//         KeyResultLatest(
//           id: 2,
//           title: 'Reducir tasa de rotación',
//           description: 'Disminuir la tasa de rotación de empleados en un 20% respecto al año anterior',
//           tag1: 'Retención',
//           tag2: 'Anual',
//         ),
//         KeyResultLatest(
//           id: 3,
//           title: 'Mejorar participación en formación',
//           description: 'Alcanzar una tasa de participación del 90% en programas de desarrollo profesional',
//           tag1: 'Desarrollo',
//           tag2: 'Mensual',
//         ),
//         KeyResultLatest(
//           id: 4,
//           title: 'Incrementar feedback regular',
//           description: 'Implementar revisiones de desempeño mensuales para el 100% del personal',
//           tag1: 'Feedback',
//           tag2: 'Mensual',
//         ),
//         KeyResultLatest(
//           id: 5,
//           title: 'Fortalecer cultura organizacional',
//           description: 'Realizar 4 eventos de team building por trimestre con participación del 80%',
//           tag1: 'Cultura',
//           tag2: 'Trimestral',
//         ),
//       ];
//     } else {
//       // English version - More comprehensive for HR objectives
//       return [
//         KeyResultLatest(
//           id: 1,
//           title: 'Increase employee satisfaction score',
//           description: 'Achieve employee satisfaction score of 85% or higher in quarterly surveys',
//           tag1: 'Survey',
//           tag2: 'Quarterly',
//         ),
//         KeyResultLatest(
//           id: 2,
//           title: 'Reduce employee turnover rate',
//           description: 'Decrease employee turnover rate by 20% compared to previous year',
//           tag1: 'Retention',
//           tag2: 'Annual',
//         ),
//         KeyResultLatest(
//           id: 3,
//           title: 'Improve training participation',
//           description: 'Achieve 90% participation rate in professional development programs',
//           tag1: 'Development',
//           tag2: 'Monthly',
//         ),
//         KeyResultLatest(
//           id: 4,
//           title: 'Increase regular feedback',
//           description: 'Implement monthly performance reviews for 100% of staff',
//           tag1: 'Feedback',
//           tag2: 'Monthly',
//         ),
//         KeyResultLatest(
//           id: 5,
//           title: 'Strengthen organizational culture',
//           description: 'Conduct 4 team building events per quarter with 80% participation',
//           tag1: 'Culture',
//           tag2: 'Quarterly',
//         ),
//         KeyResultLatest(
//           id: 6,
//           title: 'Enhance internal communication',
//           description: 'Increase internal communication platform engagement by 40%',
//           tag1: 'Communication',
//           tag2: 'Monthly',
//         ),
//         KeyResultLatest(
//           id: 7,
//           title: 'Boost employee recognition',
//           description: 'Implement peer recognition program with 70% monthly participation',
//           tag1: 'Recognition',
//           tag2: 'Monthly',
//         ),
//       ];
//     }
//   }
// }