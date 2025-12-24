import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:game_app/core/api_constants.dart';
import 'package:game_app/services/shared_preference.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';

class BonusModeController extends GetxController {
  // ============= STATE VARIABLES =============
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxBool hasPlayedToday = false.obs;
  final RxBool canPlayToday = true.obs;

  final RxInt streakDays = 0.obs;

  late RxInt remainingSeconds = 300.obs; // 5 minutes
  Timer? _countdownTimer;

  // OKR Input
  final RxString objective = ''.obs;
  final RxString keyResult1 = ''.obs;
  final RxString keyResult2 = ''.obs;
  final RxString initiative = ''.obs;

  // Evaluation Results
  final RxInt evaluationScore = 0.obs;
  final RxInt objectiveScore = 0.obs;
  final RxInt krScore = 0.obs;
  final RxInt initiativeScore = 0.obs;
  final RxInt alignmentScore = 0.obs;
  final RxInt relevanceScore = 0.obs;

  final RxString feedbackText = ''.obs;
  final RxString feedbackTone = ''.obs;
  final RxString feedbackTip = ''.obs;
  final RxList<String> strengths = <String>[].obs;
  final RxList<String> improvements = <String>[].obs;

  final RxString badgeName = ''.obs;

  // Scenario
  final RxString scenarioTitle = ''.obs;
  final RxString scenarioDescription = ''.obs;
  final RxList<String> scenarioProblems = <String>[].obs;

  // Last bonus score (for dialog when played today)
  final RxMap<String, dynamic> lastBonusScore = <String, dynamic>{}.obs;

  late Dio dio;
  late String userId;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
    _loadUserIdAndInitialize();
    _debugUserIdSources(); // Debug which sources have the user ID
  }

  void _initializeDio() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('📤 API: ${options.method} ${options.path}');
        print('   Data: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('📥 Response ${response.statusCode}: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('❌ API Error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  Future<void> _loadUserIdAndInitialize() async {
    try {
      // Get StorageRepository instance - this is where user ID is saved after login
      final storageRepo = Get.find<StorageRepository>();
      userId = storageRepo.getUserId() ?? '';

      if (userId.isNotEmpty) {
        print('✅ User ID from StorageRepository: $userId');
      } else {
        print('⚠️ StorageRepository returned empty user ID');
        // Try SharedPrefs as fallback
        userId = SharedPrefs.getUserId() ?? '';
        if (userId.isNotEmpty) {
          print('✅ User ID from SharedPrefs: $userId');
        }
      }

      // Last resort fallback
      if (userId.isEmpty) {
        userId = 'user123';
        print('⚠️ WARNING: Using fallback user ID "user123". User may not be logged in.');
      }

    } catch (e) {
      print('❌ Error getting StorageRepository: $e');
      // Fallback to SharedPrefs
      userId = SharedPrefs.getUserId() ?? 'user123';
      print('👤 Using SharedPrefs User ID: $userId');
    }

    await checkPlayedToday();
    await getStreakInfo();
    if (hasPlayedToday.value) {
      await _loadLatestScore();
    }
  }
  // ============= 1. CHECK TODAY =============
  Future<void> checkPlayedToday() async {
    try {
      isLoading.value = true;
      final response = await dio.get(ApiConstants.checkToday(userId));
      final exists = response.data['exists'] ?? false;
      hasPlayedToday.value = exists;
      canPlayToday.value = !exists;
      print('✅ Daily check: Played today = $exists');
    } catch (e) {
      print('checkPlayedToday error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============= 2. GET STREAK =============
  Future<void> getStreakInfo() async {
    try {
      final response = await dio.get(ApiConstants.streak(userId));
      streakDays.value = response.data['streak'] ?? 0;
      print('✅ Streak: ${streakDays.value} days');
    } catch (e) {
      print('getStreakInfo error: $e');
    }
  }

  // ============= 3. LOAD LATEST SCORE (for dialog) =============
  Future<void> _loadLatestScore() async {
    try {
      final response = await dio.get(ApiConstants.bonusScoreLatest(userId));
      final data = response.data;

      // FIX: Parse finalScore correctly (it comes as camelCase from API)
      evaluationScore.value = _parseInt(data['finalScore'], 0);
      badgeName.value = data['badge'] ?? 'None';

      // Also parse dimension scores if available
      if (data['dimensionScores'] != null) {
        final dim = data['dimensionScores'] as Map<String, dynamic>;
        objectiveScore.value = _parseInt(dim['objective'], 0);
        krScore.value = _parseInt(dim['keyResults'], 0);
        initiativeScore.value = _parseInt(dim['initiatives'], 0);
        alignmentScore.value = _parseInt(dim['alignment'], 0);
        relevanceScore.value = _parseInt(dim['relevance'], 0);
      }

      // Load feedback if available
      if (data['feedback'] != null) {
        final fb = data['feedback'];
        feedbackText.value = fb['text'] ?? 'No feedback';
        feedbackTone.value = fb['tone'] ?? 'neutral';
        feedbackTip.value = fb['tip'] ?? 'Keep improving';
      }

      // Load strengths and improvements
      if (data['strengths'] != null) {
        strengths.value = _parseStringList(data['strengths']);
      }
      if (data['improvements'] != null) {
        improvements.value = _parseStringList(data['improvements']);
      }

      // Store the full response
      lastBonusScore.value = data;

      print('✅ Latest score loaded: ${evaluationScore.value} | Badge: ${badgeName.value}');
    } catch (e) {
      print('_loadLatestScore error: $e');
    }
  }

  // ============= 4. GENERATE SCENARIO =============
  Future<void> generateScenario(String role, String industry) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await dio.post(
        ApiConstants.generateScenario,
        data: {
          'role': role,
          'industry': industry,
          'language': 'English',
        },
      );

      final data = response.data;
      scenarioTitle.value = data['industry'] ?? industry;
      scenarioDescription.value = data['vision'] ?? '';
      scenarioProblems.value = List<String>.from(data['problems'] ?? []);

      print('✅ Scenario loaded');
    } catch (e) {
      errorMessage.value = 'Failed to generate scenario';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ============= 5. EVALUATE RESPONSE =============
  Future<void> evaluateUserResponse({
    required String objective,
    required String keyResults,
    required String initiative,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userResponse = '''
Objective: $objective
Key Results: $keyResults
Initiative: $initiative
      '''.trim();

      final response = await dio.post(
        ApiConstants.evaluateResponse,
        data: {
          'userResponse': userResponse,
          'scenarioTitle': scenarioTitle.value,
          'scenarioDescription': scenarioDescription.value,
          'language': 'en',
        },
      );

      final data = response.data;
      print('Raw Response: $data');

      // Parse the score - check both camelCase and lowercase
      final scoreValue = data['finalScore'] ?? data['finalscore'] ?? 0;
      evaluationScore.value = _parseInt(scoreValue, 0);
      print('🎯 Parsed Final Score: ${evaluationScore.value}');

      // Parse dimension scores - handle both naming conventions
      final dim = data['dimensionScores'] ?? data['dimensionscores'] as Map<String, dynamic>? ?? {};
      objectiveScore.value = _parseInt(dim['objective'], 0);
      krScore.value = _parseInt(dim['keyResults'] ?? dim['keyresults'], 0);
      initiativeScore.value = _parseInt(dim['initiatives'], 0);
      alignmentScore.value = _parseInt(dim['alignment'], 0);
      relevanceScore.value = _parseInt(dim['relevance'], 0);

      print('📊 Dimension Scores: Obj=${objectiveScore.value}, KR=${krScore.value}, Init=${initiativeScore.value}');

      // Parse feedback
      final feedbackList = data['feedback'] as List<dynamic>?;
      if (feedbackList != null && feedbackList.isNotEmpty) {
        final fb = feedbackList[0];
        feedbackText.value = fb['text'] ?? 'No feedback';
        feedbackTone.value = fb['tone'] ?? 'neutral';
        feedbackTip.value = fb['tip'] ?? 'Keep improving';
        strengths.value = _parseStringList(fb['strengths']);
        improvements.value = _parseStringList(fb['improvements']);
      }

      // Badge - use calculated if API doesn't provide
      final apiBadge = data['badge']?.toString() ?? '';
      if (apiBadge.isNotEmpty) {
        badgeName.value = apiBadge;
      } else {
        _calculateBadge();
      }

      print('✅ Evaluation complete: Score=${evaluationScore.value}, Badge=${badgeName.value}');
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      errorMessage.value = 'Evaluation failed: $e';
      Get.snackbar('Error', errorMessage.value);
      print('❌ Evaluation error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============= 6. SUBMIT BONUS SCORE =============
  Future<bool> submitBonusScore() async {
    try {
      isLoading.value = true;

      final payload = {
        'userId': userId,
        'finalScore': evaluationScore.value,
        'badge': badgeName.value,
        'dimensionScores': {
          'objective': objectiveScore.value,
          'keyResults': krScore.value,
          'initiatives': initiativeScore.value,
          'alignment': alignmentScore.value,
          'relevance': relevanceScore.value,
        },
        'feedback': {
          'text': feedbackText.value,
          'tone': feedbackTone.value,
          'tip': feedbackTip.value,
        },
        'strengths': strengths.toList(),
        'improvements': improvements.toList(),
      };

      print('📤 Submitting score: $payload');

      final response = await dio.post(
        ApiConstants.bonusScore,
        data: payload,
      );

      lastBonusScore.value = response.data;
      await SharedPrefs.setBonusSubmitted(true);
      await getStreakInfo();
      await checkPlayedToday();

      print('✅ Score submitted successfully');
      return true;
    } catch (e) {
      print('❌ submitBonusScore error: $e');
      errorMessage.value = 'Failed to submit score: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============= TIMER =============
  void startCountdownTimer() {
    remainingSeconds.value = 300;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds.value > 0) {
        remainingSeconds--;
      } else {
        stopCountdownTimer();
        Get.snackbar('Time Up!', 'Your time has expired.');
      }
    });
  }

  void stopCountdownTimer() {
    _countdownTimer?.cancel();
  }

  String getFormattedTime() {
    final m = remainingSeconds.value ~/ 60;
    final s = remainingSeconds.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ============= SETTERS =============
  void setObjective(String val) => objective.value = val;
  void setKeyResults(String kr1, String kr2) {
    keyResult1.value = kr1;
    keyResult2.value = kr2;
  }
  void setInitiative(String val) => initiative.value = val;

  // ============= BADGE =============
  void _calculateBadge() {
    final score = evaluationScore.value;
    badgeName.value = score >= 90
        ? 'Gold'
        : score >= 75
        ? 'Silver'
        : score >= 60
        ? 'Bronze'
        : 'None';
    print('🏅 Badge calculated: ${badgeName.value} (score: $score)');
  }

  // ============= HELPERS =============
  int _parseInt(dynamic val, int def) {
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) return int.tryParse(val) ?? def;
    return def;
  }

  List<String> _parseStringList(dynamic val) {
    if (val is List) {
      return val
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  void _handleDioError(DioException e) {
    String msg = 'Network error';
    if (e.response?.statusCode == 404) msg = 'API not found';
    if (e.response?.statusCode == 500) msg = 'Server error';
    errorMessage.value = msg;
    Get.snackbar('Error', msg, backgroundColor: Colors.red, colorText: Colors.white);
  }

  @override
  void onClose() {
    stopCountdownTimer();
    super.onClose();
  }

  /// Debug method to check all sources of user ID
  void _debugUserIdSources() {
    print('\n🔍 === DEBUG USER ID SOURCES ===');
    try {
      final storageRepo = Get.find<StorageRepository>();
      final fromStorage = storageRepo.getUserId();
      print('   StorageRepository.getUserId(): $fromStorage');
    } catch (e) {
      print('   StorageRepository: ❌ Not found ($e)');
    }

    try {
      final fromSharedPrefs = SharedPrefs.getUserId();
      print('   SharedPrefs.getUserId(): $fromSharedPrefs');
    } catch (e) {
      print('   SharedPrefs: ❌ Error ($e)');
    }

    print('   Current Controller userId: $userId');
    print('🔍 === END DEBUG ===\n');
  }
}