// import 'dart:async';
// import 'dart:math';
// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:game_app/core/api_constants.dart';
// import 'package:game_app/services/shared_preference.dart';
// import 'package:game_app/data/repositories/storage_repository.dart';
// import 'package:flutter/material.dart';
//
// import '../../data/repositories/auth_repository.dart';
//
// class BonusModeController extends GetxController {
//   // ============= STATE VARIABLES =============
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//
//   final RxBool hasPlayedToday = false.obs;
//   final RxBool canPlayToday = true.obs;
//
//   final RxInt streakDays = 0.obs;
//
//   late RxInt remainingSeconds = 300.obs; // 5 minutes
//   Timer? _countdownTimer;
//
//   // OKR Input
//   final RxString objective = ''.obs;
//   final RxString keyResult1 = ''.obs;
//   final RxString keyResult2 = ''.obs;
//   final RxString initiative = ''.obs;
//
//   // Evaluation Results
//   final RxInt evaluationScore = 0.obs;
//   final RxInt objectiveScore = 0.obs;
//   final RxInt krScore = 0.obs;
//   final RxInt initiativeScore = 0.obs;
//   final RxInt alignmentScore = 0.obs;
//   final RxInt relevanceScore = 0.obs;
//
//   final RxString feedbackText = ''.obs;
//   final RxString feedbackTone = ''.obs;
//   final RxString feedbackTip = ''.obs;
//   final RxList<String> strengths = <String>[].obs;
//   final RxList<String> improvements = <String>[].obs;
//
//   final RxString badgeName = ''.obs;
//
//   // Scenario
//   final RxString scenarioTitle = ''.obs;
//   final RxString scenarioDescription = ''.obs;
//   final RxList<String> scenarioProblems = <String>[].obs;
//
//   // Last bonus score (for dialog when played today)
//   final RxMap<String, dynamic> lastBonusScore = <String, dynamic>{}.obs;
//
//   late Dio dio;
//   late String userId;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeDio();
//     _loadUserIdAndInitialize();
//     _debugUserIdSources(); // Debug which sources have the user ID
//   }
//
//   void _initializeDio() {
//     dio = Dio(BaseOptions(
//       baseUrl: ApiConstants.baseUrl,
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//       contentType: 'application/json',
//     ));
//
//     dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         print('📤 API: ${options.method} ${options.path}');
//         print('   Data: ${options.data}');
//         handler.next(options);
//       },
//       onResponse: (response, handler) {
//         print('📥 Response ${response.statusCode}: ${response.data}');
//         handler.next(response);
//       },
//       onError: (error, handler) {
//         print('❌ API Error: ${error.message}');
//         handler.next(error);
//       },
//     ));
//   }
//
//   Future<void> _loadUserIdAndInitialize() async {
//     try {
//       // Get StorageRepository instance - this is where user ID is saved after login
//       final storageRepo = Get.find<StorageRepository>();
//       userId = storageRepo.getUserId() ?? '';
//
//       if (userId.isNotEmpty) {
//         print('✅ User ID from StorageRepository: $userId');
//       } else {
//         print('⚠️ StorageRepository returned empty user ID');
//         // Try SharedPrefs as fallback
//         userId = SharedPrefs.getUserId() ?? '';
//         if (userId.isNotEmpty) {
//           print('✅ User ID from SharedPrefs: $userId');
//         }
//       }
//
//       // Last resort fallback
//       if (userId.isEmpty) {
//         userId = 'user123';
//         print('⚠️ WARNING: Using fallback user ID "user123". User may not be logged in.');
//       }
//
//     } catch (e) {
//       print('❌ Error getting StorageRepository: $e');
//       // Fallback to SharedPrefs
//       userId = SharedPrefs.getUserId() ?? 'user123';
//       print('👤 Using SharedPrefs User ID: $userId');
//     }
//
//     await checkPlayedToday();
//     await getStreakInfo();
//     if (hasPlayedToday.value) {
//       await _loadLatestScore();
//     }
//   }
//   // ============= 1. CHECK TODAY =============
//   Future<void> checkPlayedToday() async {
//     try {
//       isLoading.value = true;
//       final response = await dio.get(ApiConstants.checkToday(userId));
//       final exists = response.data['exists'] ?? false;
//       hasPlayedToday.value = exists;
//       canPlayToday.value = !exists;
//       print('✅ Daily check: Played today = $exists');
//     } catch (e) {
//       print('checkPlayedToday error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ============= 2. GET STREAK =============
//   Future<void> getStreakInfo() async {
//     try {
//       final response = await dio.get(ApiConstants.streak(userId));
//       streakDays.value = response.data['streak'] ?? 0;
//       print('✅ Streak: ${streakDays.value} days');
//     } catch (e) {
//       print('getStreakInfo error: $e');
//     }
//   }
//
//   // ============= 3. LOAD LATEST SCORE (for dialog) =============
//   Future<void> _loadLatestScore() async {
//     try {
//       final response = await dio.get(ApiConstants.bonusScoreLatest(userId));
//       final data = response.data;
//
//       // FIX: Parse finalScore correctly (it comes as camelCase from API)
//       evaluationScore.value = _parseInt(data['finalScore'], 0);
//       badgeName.value = data['badge'] ?? 'None';
//
//       // Also parse dimension scores if available
//       if (data['dimensionScores'] != null) {
//         final dim = data['dimensionScores'] as Map<String, dynamic>;
//         objectiveScore.value = _parseInt(dim['objective'], 0);
//         krScore.value = _parseInt(dim['keyResults'], 0);
//         initiativeScore.value = _parseInt(dim['initiatives'], 0);
//         alignmentScore.value = _parseInt(dim['alignment'], 0);
//         relevanceScore.value = _parseInt(dim['relevance'], 0);
//       }
//
//       // Load feedback if available
//       if (data['feedback'] != null) {
//         final fb = data['feedback'];
//         feedbackText.value = fb['text'] ?? 'No feedback';
//         feedbackTone.value = fb['tone'] ?? 'neutral';
//         feedbackTip.value = fb['tip'] ?? 'Keep improving';
//       }
//
//       // Load strengths and improvements
//       if (data['strengths'] != null) {
//         strengths.value = _parseStringList(data['strengths']);
//       }
//       if (data['improvements'] != null) {
//         improvements.value = _parseStringList(data['improvements']);
//       }
//
//       // Store the full response
//       lastBonusScore.value = data;
//
//       print('✅ Latest score loaded: ${evaluationScore.value} | Badge: ${badgeName.value}');
//     } catch (e) {
//       print('_loadLatestScore error: $e');
//     }
//   }
//
//   // ============= 4. GENERATE SCENARIO =============
//   Future<void> generateScenario(String role, String industry) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final response = await dio.post(
//         ApiConstants.generateScenario,
//         data: {
//           'role': role,
//           'industry': industry,
//           'language': 'English',
//         },
//       );
//
//       final data = response.data;
//       scenarioTitle.value = data['industry'] ?? industry;
//       scenarioDescription.value = data['vision'] ?? '';
//       scenarioProblems.value = List<String>.from(data['problems'] ?? []);
//
//       print('✅ Scenario loaded');
//     } catch (e) {
//       errorMessage.value = 'Failed to generate scenario';
//       Get.snackbar('Error', errorMessage.value);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ============= 5. EVALUATE RESPONSE =============
//   Future<void> evaluateUserResponse({
//     required String objective,
//     required String keyResults,
//     required String initiative,
//   }) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final userResponse = '''
// Objective: $objective
// Key Results: $keyResults
// Initiative: $initiative
//       '''.trim();
//
//       final response = await dio.post(
//         ApiConstants.evaluateResponse,
//         data: {
//           'userResponse': userResponse,
//           'scenarioTitle': scenarioTitle.value,
//           'scenarioDescription': scenarioDescription.value,
//           'language': 'en',
//         },
//       );
//
//       final data = response.data;
//       print('Raw Response: $data');
//
//       // Parse the score - check both camelCase and lowercase
//       final scoreValue = data['finalScore'] ?? data['finalscore'] ?? 0;
//       evaluationScore.value = _parseInt(scoreValue, 0);
//       print('🎯 Parsed Final Score: ${evaluationScore.value}');
//
//       // Parse dimension scores - handle both naming conventions
//       final dim = data['dimensionScores'] ?? data['dimensionscores'] as Map<String, dynamic>? ?? {};
//       objectiveScore.value = _parseInt(dim['objective'], 0);
//       krScore.value = _parseInt(dim['keyResults'] ?? dim['keyresults'], 0);
//       initiativeScore.value = _parseInt(dim['initiatives'], 0);
//       alignmentScore.value = _parseInt(dim['alignment'], 0);
//       relevanceScore.value = _parseInt(dim['relevance'], 0);
//
//       print('📊 Dimension Scores: Obj=${objectiveScore.value}, KR=${krScore.value}, Init=${initiativeScore.value}');
//
//       // Parse feedback
//       final feedbackList = data['feedback'] as List<dynamic>?;
//       if (feedbackList != null && feedbackList.isNotEmpty) {
//         final fb = feedbackList[0];
//         feedbackText.value = fb['text'] ?? 'No feedback';
//         feedbackTone.value = fb['tone'] ?? 'neutral';
//         feedbackTip.value = fb['tip'] ?? 'Keep improving';
//         strengths.value = _parseStringList(fb['strengths']);
//         improvements.value = _parseStringList(fb['improvements']);
//       }
//
//       // Badge - use calculated if API doesn't provide
//       final apiBadge = data['badge']?.toString() ?? '';
//       if (apiBadge.isNotEmpty) {
//         badgeName.value = apiBadge;
//       } else {
//         _calculateBadge();
//       }
//
//       print('✅ Evaluation complete: Score=${evaluationScore.value}, Badge=${badgeName.value}');
//     } on DioException catch (e) {
//       _handleDioError(e);
//     } catch (e) {
//       errorMessage.value = 'Evaluation failed: $e';
//       Get.snackbar('Error', errorMessage.value);
//       print('❌ Evaluation error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ============= 6. SUBMIT BONUS SCORE =============
//   Future<bool> submitBonusScore() async {
//     try {
//       isLoading.value = true;
//
//       final payload = {
//         'userId': userId,
//         'finalScore': evaluationScore.value,
//         'badge': badgeName.value,
//         'dimensionScores': {
//           'objective': objectiveScore.value,
//           'keyResults': krScore.value,
//           'initiatives': initiativeScore.value,
//           'alignment': alignmentScore.value,
//           'relevance': relevanceScore.value,
//         },
//         'feedback': {
//           'text': feedbackText.value,
//           'tone': feedbackTone.value,
//           'tip': feedbackTip.value,
//         },
//         'strengths': strengths.toList(),
//         'improvements': improvements.toList(),
//       };
//
//       print('📤 Submitting score: $payload');
//
//       final response = await dio.post(
//         ApiConstants.bonusScore,
//         data: payload,
//       );
//
//       lastBonusScore.value = response.data;
//       await SharedPrefs.setBonusSubmitted(true);
//       await getStreakInfo();
//       await checkPlayedToday();
//
//       print('✅ Score submitted successfully');
//       return true;
//     } catch (e) {
//       print('❌ submitBonusScore error: $e');
//       errorMessage.value = 'Failed to submit score: $e';
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ============= TIMER =============
//   void startCountdownTimer() {
//     remainingSeconds.value = 300;
//     _countdownTimer?.cancel();
//     _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (remainingSeconds.value > 0) {
//         remainingSeconds--;
//       } else {
//         stopCountdownTimer();
//         Get.snackbar('Time Up!', 'Your time has expired.');
//       }
//     });
//   }
//
//   void stopCountdownTimer() {
//     _countdownTimer?.cancel();
//   }
//
//   String getFormattedTime() {
//     final m = remainingSeconds.value ~/ 60;
//     final s = remainingSeconds.value % 60;
//     return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
//   }
//
//   // ============= SETTERS =============
//   void setObjective(String val) => objective.value = val;
//   void setKeyResults(String kr1, String kr2) {
//     keyResult1.value = kr1;
//     keyResult2.value = kr2;
//   }
//   void setInitiative(String val) => initiative.value = val;
//
//   // ============= BADGE =============
//   void _calculateBadge() {
//     final score = evaluationScore.value;
//     badgeName.value = score >= 90
//         ? 'Gold'
//         : score >= 75
//         ? 'Silver'
//         : score >= 60
//         ? 'Bronze'
//         : 'None';
//     print('🏅 Badge calculated: ${badgeName.value} (score: $score)');
//   }
//
//   // ============= HELPERS =============
//   int _parseInt(dynamic val, int def) {
//     if (val is int) return val;
//     if (val is double) return val.toInt();
//     if (val is String) return int.tryParse(val) ?? def;
//     return def;
//   }
//
//   List<String> _parseStringList(dynamic val) {
//     if (val is List) {
//       return val
//           .map((e) => e.toString())
//           .where((e) => e.isNotEmpty)
//           .toList();
//     }
//     return [];
//   }
//
//   void _handleDioError(DioException e) {
//     String msg = 'Network error';
//     if (e.response?.statusCode == 404) msg = 'API not found';
//     if (e.response?.statusCode == 500) msg = 'Server error';
//     errorMessage.value = msg;
//     Get.snackbar('Error', msg, backgroundColor: Colors.red, colorText: Colors.white);
//   }
//
//   @override
//   void onClose() {
//     stopCountdownTimer();
//     super.onClose();
//   }
//
//   /// Debug method to check all sources of user ID
//   void _debugUserIdSources() {
//     print('\n🔍 === DEBUG USER ID SOURCES ===');
//     try {
//       final storageRepo = Get.find<StorageRepository>();
//       final fromStorage = storageRepo.getUserId();
//       print('   StorageRepository.getUserId(): $fromStorage');
//     } catch (e) {
//       print('   StorageRepository: ❌ Not found ($e)');
//     }
//
//     try {
//       final fromSharedPrefs = SharedPrefs.getUserId();
//       print('   SharedPrefs.getUserId(): $fromSharedPrefs');
//     } catch (e) {
//       print('   SharedPrefs: ❌ Error ($e)');
//     }
//
//     print('   Current Controller userId: $userId');
//     print('🔍 === END DEBUG ===\n');
//   }
// }
import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:game_app/core/api_constants.dart';
import 'package:game_app/services/shared_preference.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; // ✅ Add this import

import '../../data/repositories/auth_repository.dart';

class BonusModeController extends GetxController {
  // ============= STATE VARIABLES =============
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxBool hasPlayedToday = false.obs;
  final RxBool canPlayToday = true.obs;

  final RxInt streakDays = 0.obs;

  late RxInt remainingSeconds = 600.obs; // 10 minutes
  Timer? _countdownTimer;
  final RxBool timeExpired = false.obs; // ✅ NEW: Track if time is expired

  // Language setting - Load from SharedPrefs
  late RxString currentLanguage;

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

  // Store original English text for re-translation
  final Map<String, String> _originalTexts = {};

  late Dio dio;
  late String userId;

  // Translation cache to avoid redundant API calls
  final Map<String, String> _translationCache = {};

  @override
  void onInit() {
    super.onInit();

    // Initialize language from SharedPrefs
    currentLanguage = RxString(SharedPrefs.getLanguagePreference());
    print('🌍 Initial language loaded: ${currentLanguage.value}');

    _initializeDio();
    _loadUserIdAndInitialize();
    _debugUserIdSources();
  }

  void _initializeDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
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
      ),
    );
  }

  Future<void> _loadUserIdAndInitialize() async {
    try {
      final storageRepo = Get.find<StorageRepository>();
      userId = storageRepo.getUserId() ?? '';

      if (userId.isNotEmpty) {
        print('✅ User ID from StorageRepository: $userId');
      } else {
        print('⚠️ StorageRepository returned empty user ID');
        userId = SharedPrefs.getUserId() ?? '';
        if (userId.isNotEmpty) {
          print('✅ User ID from SharedPrefs: $userId');
        }
      }

      if (userId.isEmpty) {
        userId = 'user123';
        print('⚠️ WARNING: Using fallback user ID "user123".');
      }
    } catch (e) {
      print('❌ Error getting StorageRepository: $e');
      userId = SharedPrefs.getUserId() ?? 'user123';
      print('👤 Using SharedPrefs User ID: $userId');
    }

    await checkPlayedToday();
    await getStreakInfo();
    if (hasPlayedToday.value) {
      await _loadLatestScore();
    }
  }

  // ============= LANGUAGE MANAGEMENT =============
  void setLanguage(String languageCode) {
    if (currentLanguage.value == languageCode) return;

    currentLanguage.value = languageCode;

    // Save to SharedPrefs
    SharedPrefs.saveLanguagePreference(languageCode);

    _translationCache.clear();
    print('🌍 Language changed to: $languageCode');

    // Re-translate existing data
    _retranslateAllData();
  }

  Future<void> _retranslateAllData() async {
    print('🔄 Starting re-translation of all data...');

    // Re-translate scenario data
    if (_originalTexts.containsKey('scenarioTitle')) {
      scenarioTitle.value =
      await _translateText(_originalTexts['scenarioTitle']!);
    }
    if (_originalTexts.containsKey('scenarioDescription')) {
      scenarioDescription.value =
      await _translateText(_originalTexts['scenarioDescription']!);
    }

    // Re-translate problems if they exist
    if (_originalTexts.containsKey('scenarioProblems')) {
      final originalProblems =
      _originalTexts['scenarioProblems']!.split('||SEPARATOR||');
      scenarioProblems.value =
      await _translateList(originalProblems);
    }

    // Re-translate feedback
    if (_originalTexts.containsKey('feedbackText')) {
      feedbackText.value =
      await _translateText(_originalTexts['feedbackText']!);
    }
    if (_originalTexts.containsKey('feedbackTone')) {
      feedbackTone.value =
      await _translateText(_originalTexts['feedbackTone']!);
    }
    if (_originalTexts.containsKey('feedbackTip')) {
      feedbackTip.value =
      await _translateText(_originalTexts['feedbackTip']!);
    }

    // Re-translate strengths and improvements
    if (_originalTexts.containsKey('strengths')) {
      final originalStrengths =
      _originalTexts['strengths']!.split('||SEPARATOR||');
      strengths.value = await _translateList(originalStrengths);
    }
    if (_originalTexts.containsKey('improvements')) {
      final originalImprovements =
      _originalTexts['improvements']!.split('||SEPARATOR||');
      improvements.value =
      await _translateList(originalImprovements);
    }

    print('✅ All data re-translated to ${currentLanguage.value}');
  }

  Future<String> _translateText(String text) async {
    if (text.isEmpty || currentLanguage.value == 'en') {
      return text;
    }

    // Check cache first
    final cacheKey = '${currentLanguage.value}::$text';
    if (_translationCache.containsKey(cacheKey)) {
      print('💾 Using cached translation for: $text');
      return _translationCache[cacheKey]!;
    }

    try {
      final langCode = currentLanguage.value == 'es' ? 'es' : 'fr';
      print('🔄 Translating "$text" to $langCode...');

      final response = await dio.get(
        'https://api.mymemory.translated.net/get',
        queryParameters: {
          'q': text,
          'langpair': 'en|$langCode',
        },
      );

      final translatedText =
          response.data?['responseData']?['translatedText'] ?? text;
      final result = translatedText as String;

      // Cache the translation
      _translationCache[cacheKey] = result;
      print('✅ Translation cached: $text -> $result');

      return result;
    } catch (e) {
      print('❌ Translation error for "$text": $e');
      return text;
    }
  }

  Future<List<String>> _translateList(List<String> items) async {
    if (currentLanguage.value == 'en' || items.isEmpty) {
      return items;
    }

    print('🔄 Translating ${items.length} items...');
    final translated = <String>[];
    for (final item in items) {
      translated.add(await _translateText(item));
    }
    return translated;
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

  // ============= 3. LOAD LATEST SCORE =============
  Future<void> _loadLatestScore() async {
    try {
      print('📥 Loading latest score...');
      final response = await dio.get(ApiConstants.bonusScoreLatest(userId));
      final data = response.data;

      evaluationScore.value = _parseInt(data['finalScore'], 0);
      badgeName.value = data['badge'] ?? 'none'.tr;

      if (data['dimensionScores'] != null) {
        final dim = data['dimensionScores'] as Map<String, dynamic>;
        objectiveScore.value = _parseInt(dim['objective'], 0);
        krScore.value = _parseInt(dim['keyResults'], 0);
        initiativeScore.value = _parseInt(dim['initiatives'], 0);
        alignmentScore.value = _parseInt(dim['alignment'], 0);
        relevanceScore.value = _parseInt(dim['relevance'], 0);
      }

      if (data['feedback'] != null) {
        final fb = data['feedback'];
        final feedbackTextValue = fb['text'] ?? 'No feedback';
        final feedbackToneValue = fb['tone'] ?? 'neutral';
        final feedbackTipValue = fb['tip'] ?? 'Keep improving';

        // Store original English text
        _originalTexts['feedbackText'] = feedbackTextValue;
        _originalTexts['feedbackTone'] = feedbackToneValue;
        _originalTexts['feedbackTip'] = feedbackTipValue;

        // Translate if needed
        feedbackText.value = await _translateText(feedbackTextValue);
        feedbackTone.value = await _translateText(feedbackToneValue);
        feedbackTip.value = await _translateText(feedbackTipValue);

        print('✅ Feedback translated');
      }

      if (data['strengths'] != null) {
        final strengthsList = _parseStringList(data['strengths']);
        _originalTexts['strengths'] = strengthsList.join('||SEPARATOR||');
        strengths.value = await _translateList(strengthsList);
      }

      if (data['improvements'] != null) {
        final improvementsList = _parseStringList(data['improvements']);
        _originalTexts['improvements'] = improvementsList.join('||SEPARATOR||');
        improvements.value = await _translateList(improvementsList);
      }

      lastBonusScore.value = data;
      print(
        '✅ Latest score loaded: ${evaluationScore.value} | Badge: ${badgeName.value}',
      );
    } catch (e) {
      print('_loadLatestScore error: $e');
    }
  }

  // ============= 4. GENERATE SCENARIO =============
  Future<void> generateScenario(String role, String industry) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔄 Generating scenario in ${currentLanguage.value}...');

      final response = await dio.post(
        ApiConstants.generateScenario,
        data: {
          'role': role,
          'industry': industry,
          'language': 'en', // Always get English from API
        },
      );

      final data = response.data;

      // Store original English text
      final industryValue = data['industry'] ?? industry;
      final visionValue = data['vision'] ?? '';
      final problemsList = List<String>.from(data['problems'] ?? []);

      _originalTexts['scenarioTitle'] = industryValue;
      _originalTexts['scenarioDescription'] = visionValue;
      _originalTexts['scenarioProblems'] = problemsList.join('||SEPARATOR||');

      // Translate to selected language
      scenarioTitle.value = await _translateText(industryValue);
      scenarioDescription.value = await _translateText(visionValue);
      scenarioProblems.value = await _translateList(problemsList);

      print('✅ Scenario generated and translated to ${currentLanguage.value}');
    } catch (e) {
      errorMessage.value = 'Failed to generate scenario';
      Get.snackbar('Error', errorMessage.value);
      print('❌ generateScenario error: $e');
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

      print('🔄 Evaluating response in ${currentLanguage.value}...');

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

      final scoreValue = data['finalScore'] ?? data['finalscore'] ?? 0;
      evaluationScore.value = _parseInt(scoreValue, 0);
      print('🎯 Parsed Final Score: ${evaluationScore.value}');

      final dim = data['dimensionScores'] ??
          data['dimensionscores'] as Map<String, dynamic>? ?? {};
      objectiveScore.value = _parseInt(dim['objective'], 0);
      krScore.value = _parseInt(dim['keyResults'] ?? dim['keyresults'], 0);
      initiativeScore.value = _parseInt(dim['initiatives'], 0);
      alignmentScore.value = _parseInt(dim['alignment'], 0);
      relevanceScore.value = _parseInt(dim['relevance'], 0);

      print(
        '📊 Dimension Scores: Obj=${objectiveScore.value}, KR=${krScore.value}, Init=${initiativeScore.value}',
      );

      final feedbackList = data['feedback'] as List<dynamic>?;
      if (feedbackList != null && feedbackList.isNotEmpty) {
        final fb = feedbackList[0];
        final feedbackTextValue = fb['text'] ?? 'No feedback';
        final feedbackToneValue = fb['tone'] ?? 'neutral';
        final feedbackTipValue = fb['tip'] ?? 'Keep improving';
        final strengthsList = _parseStringList(fb['strengths']);
        final improvementsList = _parseStringList(fb['improvements']);

        // Store original English text
        _originalTexts['feedbackText'] = feedbackTextValue;
        _originalTexts['feedbackTone'] = feedbackToneValue;
        _originalTexts['feedbackTip'] = feedbackTipValue;
        _originalTexts['strengths'] = strengthsList.join('||SEPARATOR||');
        _originalTexts['improvements'] = improvementsList.join('||SEPARATOR||');

        // Translate to selected language
        feedbackText.value = await _translateText(feedbackTextValue);
        feedbackTone.value = await _translateText(feedbackToneValue);
        feedbackTip.value = await _translateText(feedbackTipValue);
        strengths.value = await _translateList(strengthsList);
        improvements.value = await _translateList(improvementsList);

        print('✅ Feedback evaluated and translated');
      }

      final apiBadge = data['badge']?.toString() ?? '';
      if (apiBadge.isNotEmpty) {
        badgeName.value = apiBadge;
      } else {
        _calculateBadge();
      }

      print(
        '✅ Evaluation complete: Score=${evaluationScore.value}, Badge=${badgeName.value}',
      );
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
        'language': currentLanguage.value,
      };

      print('📤 Submitting score: $payload');

      final response = await dio.post(ApiConstants.bonusScore, data: payload);

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

  // ============= TIMER (UPDATED) =============
  // ============= TIMER (UPDATED WITH FIXED VIBRATION) =============
  void startCountdownTimer() {
    remainingSeconds.value = 600; // 10 minutes = 600 seconds
    timeExpired.value = false; // ✅ Reset time expired flag
    _countdownTimer?.cancel();
    print('⏱️ Timer started: 10 minutes');

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds.value > 0) {
        remainingSeconds--;

        // ✅ TRIGGER AT 10 SECONDS
        if (remainingSeconds.value == 10) {
          print('⏱️ WARNING: 10 seconds remaining!');
          _triggerTimeWarningAlert();
        }

        // ✅ TRIGGER AT 0 SECONDS
        if (remainingSeconds.value == 0) {
          print('⏱️ TIME EXPIRED!');
          timeExpired.value = true;
          _triggerTimeExpiredAlert();
        }
      }
    });
  }

// ✅ TRIGGERED WHEN 10 SECONDS LEFT
  void _triggerTimeWarningAlert() {
    _simpleVibrate(duration: 100); // Light vibration
    print('📳 Light vibration triggered at 10 seconds');
  }

// ✅ TRIGGERED WHEN TIME EXPIRES
  void _triggerTimeExpiredAlert() {
    _simpleVibrate(duration: 500); // Strong vibration
    print('📳 Strong vibration triggered - TIME EXPIRED');
  }

// ✅ SIMPLE VIBRATION WITHOUT EXTERNAL DEPENDENCIES
  void _simpleVibrate({required int duration}) {
    try {
      // Using HapticFeedback from Flutter (built-in, no dependency needed)

      if (duration >= 200) {
        HapticFeedback.heavyImpact(); // Strong vibration
        print('✅ Heavy haptic feedback triggered');
      } else {
        HapticFeedback.lightImpact(); // Light vibration
        print('✅ Light haptic feedback triggered');
      }
    } catch (e) {
      print('⚠️ Haptic feedback error: $e (This is OK, feature may not be available)');
    }
  }

  void stopCountdownTimer() {
    _countdownTimer?.cancel();
    print('⏱️ Timer stopped');
  }

  String getFormattedTime() {
    final m = remainingSeconds.value ~/ 60;
    final s = remainingSeconds.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool isTimeExpired_() => timeExpired.value; // ✅ Check if time expired
  bool isTimeWarning() => remainingSeconds.value < 60; // Flash when < 1 minute
  // ✅ VIBRATION HELPER
  Future<void> _vibrateDevice({bool pattern = false}) async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        if (pattern) {
          // ✅ Strong vibration pattern when time expired
          await Vibration.vibrate(duration: 500); // 500ms vibration
          await Future.delayed(const Duration(milliseconds: 200));
          await Vibration.vibrate(duration: 500); // Another 500ms
        } else {
          // ✅ Light vibration at 10 seconds
          await Vibration.vibrate(duration: 100); // 100ms light vibration
        }
      }
    } catch (e) {
      print('❌ Vibration error: $e');
    }
  }

  // void stopCountdownTimer() {
  //   _countdownTimer?.cancel();
  //   print('⏱️ Timer stopped');
  // }
  //
  // String getFormattedTime() {
  //   final m = remainingSeconds.value ~/ 60;
  //   final s = remainingSeconds.value % 60;
  //   return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  // }
  //
  // bool isTimeExpired_() => timeExpired.value; // ✅ Check if time expired
  // bool isTimeWarning() => remainingSeconds.value < 60; // Flash when < 1 minute

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
        : 'none'.tr;
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
      return val.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }

  void _handleDioError(DioException e) {
    String msg = 'Network error';
    if (e.response?.statusCode == 404) msg = 'API not found';
    if (e.response?.statusCode == 500) msg = 'Server error';
    errorMessage.value = msg;
    Get.snackbar(
      'Error',
      msg,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    stopCountdownTimer();
    super.onClose();
  }

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
    print('   Current Language: ${currentLanguage.value}');
    print('🔍 === END DEBUG ===\n');
  }
}
