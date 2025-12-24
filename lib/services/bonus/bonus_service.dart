// // lib/domain/services/bonus_service.dart
// import '../../../services/shared_preference.dart';
// import '../../generated/models/bonus/bonus_model.dart';
// import '../../repository/bonus/bonus_repo.dart';
//
// class BonusService {
//   final BonusRepository _repo = BonusRepository();
//
//   Future<bool> hasPlayedToday() async {
//     final userId = SharedPrefs.getUserId() ?? 'user123';
//     final result = await _repo.checkToday(userId);
//     return result.exists;
//   }
//
//   Future<int> getCurrentStreak() async {
//     final userId = SharedPrefs.getUserId() ?? 'user123';
//     final result = await _repo.getStreak(userId);
//     return result.streak;
//   }
//
//   Future<BonusEvaluationResponse?> getLatestEvaluation() async {
//     final userId = SharedPrefs.getUserId() ?? 'user123';
//     try {
//       return await _repo.getLatestScore(userId);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   Future<BonusScenarioResponse> generateDailyScenario(String role, String industry) async {
//     return await _repo.generateScenario(role, industry);
//   }
//
//   Future<BonusEvaluationResponse> submitUserResponse({
//     required String userResponse,
//     required String title,
//     required String description,
//   }) async {
//     final evaluation = await _repo.evaluateResponse(
//       userResponse: userResponse,
//       scenarioTitle: title,
//       scenarioDescription: description,
//     );
//
//     final userId = SharedPrefs.getUserId() ?? 'user123';
//     await _repo.submitBonusScore({
//       "userId": userId,
//       "finalScore": evaluation.finalScore,
//       "badge": evaluation.badge,
//       "dimensionScores": evaluation.dimensionScores,
//       "feedback": {
//         "text": evaluation.feedbackText,
//         "tone": evaluation.feedbackTone,
//         "tip": evaluation.feedbackTip,
//       },
//       "strengths": evaluation.strengths,
//       "improvements": evaluation.improvements,
//     });
//
//     return evaluation;
//   }
// }