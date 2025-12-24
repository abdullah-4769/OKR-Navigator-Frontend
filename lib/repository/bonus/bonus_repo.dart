// // lib/data/repositories/bonus_repository.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../../core/api_constants.dart';
// import '../../generated/models/bonus/bonus_model.dart';
//
// class BonusRepository {
//   // 1. Check if played today
//   Future<CheckTodayResponse> checkToday(String userId) async {
//     final response = await http.get(Uri.parse(ApiConstants.checkToday(userId)));
//     if (response.statusCode == 200) {
//       return CheckTodayResponse.fromJson(jsonDecode(response.body));
//     }
//     throw Exception('Failed to check today');
//   }
//
//   // 2. Get streak
//   Future<StreakResponse> getStreak(String userId) async {
//     final response = await http.get(Uri.parse(ApiConstants.streak(userId)));
//     if (response.statusCode == 200) {
//       return StreakResponse.fromJson(jsonDecode(response.body));
//     }
//     throw Exception('Failed to get streak');
//   }
//
//   // 3. Get latest bonus score
//   Future<BonusEvaluationResponse> getLatestScore(String userId) async {
//     final response = await http.get(Uri.parse(ApiConstants.bonusScoreLatest(userId)));
//     if (response.statusCode == 200) {
//       return BonusEvaluationResponse.fromJson(jsonDecode(response.body));
//     }
//     throw Exception('Failed to get latest score');
//   }
//
//   // 4. Generate scenario
//   Future<BonusScenarioResponse> generateScenario(String role, String industry) async {
//     final response = await http.post(
//       Uri.parse(ApiConstants.generateScenario),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "role": role,
//         "industry": industry,
//         "language": "English",
//       }),
//     );
//     if (response.statusCode == 200) {
//       return BonusScenarioResponse.fromJson(jsonDecode(response.body));
//     }
//     throw Exception('Failed to generate scenario');
//   }
//
//   // 5. Evaluate response
//   Future<BonusEvaluationResponse> evaluateResponse({
//     required String userResponse,
//     required String scenarioTitle,
//     required String scenarioDescription,
//   }) async {
//     final response = await http.post(
//       Uri.parse(ApiConstants.evaluateResponse),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "userResponse": userResponse,
//         "scenarioTitle": scenarioTitle,
//         "scenarioDescription": scenarioDescription,
//         "language": "en",
//       }),
//     );
//     if (response.statusCode == 200) {
//       return BonusEvaluationResponse.fromJson(jsonDecode(response.body));
//     }
//     throw Exception('Failed to evaluate');
//   }
//
//   // 6. Submit bonus score
//   Future<BonusEvaluationResponse> submitBonusScore(Map<String, dynamic> body) async {
//     final response = await http.post(
//       Uri.parse(ApiConstants.bonusScore),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(body),
//     );
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return BonusEvaluationResponse.fromJson(jsonDecode(response.body));
//     }
//     throw Exception('Failed to submit score');
//   }
// }