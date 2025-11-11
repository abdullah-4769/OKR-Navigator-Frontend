import 'package:flutter/material.dart';
import 'package:game_app/controllers/key_objective_controller.dart';
import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/controllers/strategy_selection_controller.dart';
import 'package:game_app/data/response/api_response.dart';
import 'package:game_app/data/response/status.dart';
import 'package:get/get.dart';
import '../../data/repositories/contextual_challenge_repo.dart';
import '../../generated/models/responses/contexual_challenge/contextual_challenge_model.dart';

class ChallengeViewModel extends GetxController {
  final ChallengeRepository _repository = ChallengeRepository();

  var apiResponse = Rx<ApiResponse<ChallengeResponse>>(ApiResponse.loading());
  var isLoading = false.obs;
  var challengeTitle = ''.obs;
  var challengeText = ''.obs;
  var previousAttempts = 1.obs;

  @override
  void onInit() {
    super.onInit();
    print('[ChallengeViewModel] Initialized');
    fetchChallenge();
  }

  Future<void> fetchChallenge() async {
    print('----------------------------------------');
    print('[ChallengeViewModel] Fetching challenge...');
    try {
      isLoading.value = true;
      apiResponse.value = ApiResponse.loading();
      print('[ChallengeViewModel] Loading set to TRUE');

      // Get controllers
      final strategyController = Get.find<StrategySelectionController>();
      final objectiveController = Get.find<KeyObjectiveController>();
      final languageController = Get.find<LanguageController>();

      final strategyTitle = strategyController.selectedStrategy.value?.title;
      final objectiveTitle = objectiveController.selectedObjective.value?.title;
      final language = languageController.selectedLanguage.value?.name ?? 'en';
      final keyResultTitle = 'default_key_result';

      print('[ChallengeViewModel] Strategy: $strategyTitle');
      print('[ChallengeViewModel] Objective: $objectiveTitle');
      print('[ChallengeViewModel] Language: $language');
      print('[ChallengeViewModel] Previous Attempts: ${previousAttempts.value}');
      print('[ChallengeViewModel] KeyResult: $keyResultTitle');

      if (strategyTitle == null || objectiveTitle == null) {
        print('[ChallengeViewModel][ERROR] Missing strategy or objective');
        apiResponse.value = ApiResponse.error('Strategy and Objective required');
        Get.snackbar(
          'error'.tr,
          'Strategy and Objective required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      print('[ChallengeViewModel] Calling repository.getChallenge()...');
      final response = await _repository.getChallenge(
        strategy: strategyTitle,
        objective: objectiveTitle,
        keyResult: keyResultTitle,
        previousAttempts: previousAttempts.value,
        language: language,
      );

      print('[ChallengeViewModel] Response Status: ${response.status}');
      print('[ChallengeViewModel] Response Message: ${response.message}');
      apiResponse.value = response;

      if (response.status == Status.completed && response.data != null) {
        challengeTitle.value = response.data?.title ?? '';
        challengeText.value = response.data?.text ?? '';
        print('[ChallengeViewModel] ✅ Challenge Loaded Successfully');
        print('[ChallengeViewModel] Title: ${challengeTitle.value}');
        print('[ChallengeViewModel] Text: ${challengeText.value}');
      } else {
        print('[ChallengeViewModel][ERROR] Failed to load challenge - ${response.message}');
        Get.snackbar(
          'error'.tr,
          response.message ?? 'Failed to load challenge',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, s) {
      print('[ChallengeViewModel][EXCEPTION] $e');
      print('[ChallengeViewModel][STACKTRACE] $s');
      apiResponse.value = ApiResponse.error(e.toString());
      Get.snackbar(
        'error'.tr,
        'Error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      print('[ChallengeViewModel] Loading set to FALSE');
      print('----------------------------------------');
    }
  }

  Future<void> retryChallenge() async {
    previousAttempts.value++;
    print('[ChallengeViewModel] Retrying Challenge... Attempt: ${previousAttempts.value}');
    await fetchChallenge();
  }

  bool get hasData => apiResponse.value.status == Status.completed;
  ChallengeResponse? get challengeData => apiResponse.value.data;

  String get marketDisruptionTitle => challengeTitle.value;
  String get marketDisruptionDescription => challengeText.value;



}
