import 'package:get/get.dart';
import '../data/repositories/bonus_score_repo.dart';
import '../generated/models/bonus_score_model.dart';

import '../services/shared_preference.dart';

class BonusScoreController extends GetxController {
  final BonusScoreRepository _repository = BonusScoreRepository();

  final Rx<BonusScoreResponse?> latestBonusScore = Rx<BonusScoreResponse?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasSubmittedBonus = false.obs;
  final RxString errorMessage = ''.obs;

  // Check if user is in bonus mode
  Future<bool> isBonusMode() async {
    final savedMode = await SharedPrefs.getGameMode();
    return savedMode == 'bonus';
  }

  // Submit bonus score
  Future<bool> submitBonusScore({
    required int overallScore,
    required String normalizedScore,
    required String points,
    required String title,
    required String feedback,
    required String strategyAlignmentTitle,
    required int strategyAlignmentScore,
    required String strategyAlignmentSuggestion,
    required String objectiveAlignmentTitle,
    required int objectiveAlignmentScore,
    required String objectiveAlignmentSuggestion,
    required String keyResultQualityTitle,
    required int keyResultQualityScore,
    required String keyResultQualitySuggestion,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userId = SharedPrefs.getUserId() ?? 'user123';

      final request = BonusScoreRequest(
        id: 0, // Will be assigned by backend
        userId: userId,
        overallScore: overallScore,
        normalizedScore: normalizedScore,
        points: points,
        title: title,
        feedback: feedback,
        strategyAlignmentTitle: strategyAlignmentTitle,
        strategyAlignmentScore: strategyAlignmentScore,
        strategyAlignmentSuggestion: strategyAlignmentSuggestion,
        objectiveAlignmentTitle: objectiveAlignmentTitle,
        objectiveAlignmentScore: objectiveAlignmentScore,
        objectiveAlignmentSuggestion: objectiveAlignmentSuggestion,
        keyResultQualityTitle: keyResultQualityTitle,
        keyResultQualityScore: keyResultQualityScore,
        keyResultQualitySuggestion: keyResultQualitySuggestion,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      final response = await _repository.submitBonusScore(request);

      if (response != null) {
        hasSubmittedBonus.value = true;

        // Save bonus score locally
        await SharedPrefs.saveBonusScore(overallScore);

        print('✅ Bonus score submitted successfully: ${response.overallScore}');
        return true;
      } else {
        errorMessage.value = 'Failed to submit bonus score';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error submitting bonus score: $e';
      print('❌ Error submitting bonus score: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get latest bonus score
  Future<void> getLatestBonusScore() async {
    try {
      isLoading.value = true;
      final userId = SharedPrefs.getUserId() ?? 'user123';

      final response = await _repository.getLatestBonusScore(userId);

      if (response != null) {
        latestBonusScore.value = response;
        print('✅ Latest bonus score loaded: ${response.overallScore}');
      }
    } catch (e) {
      print('❌ Error getting latest bonus score: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Check if bonus score should be submitted
  Future<bool> shouldSubmitBonusScore() async {
    final isBonus = await isBonusMode();
    final hasSubmitted = hasSubmittedBonus.value;
    final hasLocalScore = SharedPrefs.getBonusScore() > 0;

    return isBonus && !hasSubmitted && !hasLocalScore;
  }

  // Clear bonus data
  void clearBonusData() {
    latestBonusScore.value = null;
    hasSubmittedBonus.value = false;
    errorMessage.value = '';
  }
}