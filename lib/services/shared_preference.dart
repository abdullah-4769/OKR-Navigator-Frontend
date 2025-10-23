import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// 🎯 SharedPreferences Wrapper - Complete Version
class SharedPrefs {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences (call once in main.dart)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  static const String keyCorrectStrategyId = 'correct_strategy_id';
  static const String keyCampaignScenario = 'campaign_scenario';

  // Save correct strategy ID
  static Future<void> saveCorrectStrategyId(int strategyId) async {
    await _prefs?.setInt(keyCorrectStrategyId, strategyId);
  }

  // Get correct strategy ID
  static int getCorrectStrategyId() {
    return _prefs?.getInt(keyCorrectStrategyId) ?? 0;
  }

  // Save campaign scenario
  static Future<void> saveCampaignScenario(String scenario) async {
    await _prefs?.setString(keyCampaignScenario, scenario);
  }

  // Get campaign scenario
  static String? getCampaignScenario() {
    return _prefs?.getString(keyCampaignScenario);
  }

  // Generic save methods
  static Future<void> saveInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }
// Save certification evaluation result
  static Future<void> saveCertificationEvaluationResult(Map<String, dynamic> result) async {
    final jsonString = jsonEncode(result);
    await _prefs?.setString('certification_evaluation_result', jsonString);
    print('💾 Saved certification evaluation result');
  }

// Get certification evaluation result
  static Map<String, dynamic>? getCertificationEvaluationResult() {
    final jsonString = _prefs?.getString('certification_evaluation_result');
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      print('❌ Error parsing certification evaluation result: $e');
      return null;
    }
  }


// Clear certification evaluation result
  static Future<void> clearCertificationEvaluationResult() async {
    await _prefs?.remove('certification_evaluation_result');
    print('🧹 Cleared certification evaluation result');
  }
  //
  // static Future<void> saveString(String key, String value) async {
  //   await _prefs?.setString(key, value);
  // }
  // ===========================================================================
  // 🔹 USER AUTHENTICATION & PROFILE
  // ===========================================================================

  static const String keyUserId = 'userId';
  static const String keyUserName = 'userName';
  static const String keyUserRole = 'userRole';
  static const String keySelectedRoleIndex = 'selectedRoleIndex';

  static Future<void> saveUserId(String id) async {
    await _prefs?.setString(keyUserId, id);
  }

  static String? getUserId() {
    return _prefs?.getString(keyUserId);
  }

  static Future<void> saveUserName(String name) async {
    await _prefs?.setString(keyUserName, name);
  }

  static String? getUserName() {
    return _prefs?.getString(keyUserName);
  }

  static Future<void> saveUserRole(String role) async {
    await _prefs?.setString(keyUserRole, role);
  }

  static String? getUserRole() {
    return _prefs?.getString(keyUserRole);
  }

  static Future<void> saveSelectedRoleIndex(int index) async {
    await _prefs?.setInt(keySelectedRoleIndex, index);
  }

  static int getSelectedRoleIndex() {
    return _prefs?.getInt(keySelectedRoleIndex) ?? -1;
  }

  // ===========================================================================
  // 🔹 CHALLENGE MANAGEMENT
  // ===========================================================================

  static const String keyHostId = 'hostId';
  static const String keyChallengeId = 'challengeId';
  static const String keyJoinChallengeId = 'joinChallengeId';
  static const String keyAcceptChallengeId = 'acceptChallengeId';
  static const String keyAcceptInviteChallengeId = 'acceptInviteChallengeId';

  static Future<void> saveHostId(String id) async {
    await _prefs?.setString(keyHostId, id);
  }

  static String? getHostId() {
    return _prefs?.getString(keyHostId);
  }

  static Future<void> saveChallengeId(String challengeId) async {
    await _prefs?.setString(keyChallengeId, challengeId);
  }

  static Future<String?> getChallengeId() async {
    return _prefs?.getString(keyChallengeId);
  }

  static Future<void> saveJoinChallengeId(String challengeId) async {
    await _prefs?.setString(keyJoinChallengeId, challengeId);
  }

  static String? getJoinChallengeId() {
    return _prefs?.getString(keyJoinChallengeId);
  }

  static Future<void> saveAcceptChallengeId(String challengeId) async {
    await _prefs?.setString(keyAcceptChallengeId, challengeId);
  }

  static String? getAcceptChallengeId() {
    return _prefs?.getString(keyAcceptChallengeId);
  }

  static Future<void> saveAcceptInviteChallengeId(String challengeId) async {
    await _prefs?.setString(keyAcceptInviteChallengeId, challengeId);
  }

  static String? getAcceptInviteChallengeId() {
    return _prefs?.getString(keyAcceptInviteChallengeId);
  }

  // ===========================================================================
  // 🔹 GAME MODE
  // ===========================================================================

  static const String keyGameMode = 'game_mode';

  static Future<void> saveGameMode(String gameMode) async {
    await _prefs?.setString(keyGameMode, gameMode);
  }

  static String? getGameMode() {
    return _prefs?.getString(keyGameMode);
  }

  static Future<void> clearGameMode() async {
    await _prefs?.remove(keyGameMode);
  }

  // ===========================================================================
  // 🔹 INDUSTRY SELECTION
  // ===========================================================================

  static const String keySelectedIndustryTitle = 'selectedIndustryTitle';
  static const String keySelectedIndustryDesc = 'selectedIndustryDesc';
  static const String keySelectedIndustryIcon = 'selectedIndustryIcon';

  static Future<void> saveSelectedIndustry(Map<String, dynamic> industry) async {
    await _prefs?.setString(
      keySelectedIndustryTitle,
      industry['titleKey'].toString(),
    );
    await _prefs?.setString(
      keySelectedIndustryDesc,
      industry['descriptionKey'].toString(),
    );
    await _prefs?.setString(
      keySelectedIndustryIcon,
      _iconToString(industry['icon']),
    );
  }

  static Map<String, dynamic>? getSelectedIndustry() {
    final title = _prefs?.getString(keySelectedIndustryTitle);
    final desc = _prefs?.getString(keySelectedIndustryDesc);
    final iconName = _prefs?.getString(keySelectedIndustryIcon);

    if (title == null) return null;

    return {
      'titleKey': title,
      'descriptionKey': desc ?? '',
      'icon': _stringToIcon(iconName),
    };
  }

  static Future<void> clearSelectedIndustry() async {
    await _prefs?.remove(keySelectedIndustryTitle);
    await _prefs?.remove(keySelectedIndustryDesc);
    await _prefs?.remove(keySelectedIndustryIcon);
  }

  // ===========================================================================
  // 🔹 CAMPAIGN SUGGESTION (AI Generated)
  // ===========================================================================

  static const String keyCampaignSuggestionName = 'campaignSuggestionName';
  static const String keyCampaignSuggestionDesc = 'campaignSuggestionDesc';

  static Future<void> saveCampaignSuggestion(
      String name,
      String description,
      ) async {
    await _prefs?.setString(keyCampaignSuggestionName, name);
    await _prefs?.setString(keyCampaignSuggestionDesc, description);
  }

  static String? getCampaignSuggestionName() {
    return _prefs?.getString(keyCampaignSuggestionName);
  }

  static String? getCampaignSuggestionDescription() {
    return _prefs?.getString(keyCampaignSuggestionDesc);
  }

  static Future<void> clearCampaignSuggestion() async {
    await _prefs?.remove(keyCampaignSuggestionName);
    await _prefs?.remove(keyCampaignSuggestionDesc);
  }
// ================== CERTIFICATION DATA METHODS ==================
  static Future<void> saveCertificateSelectedAIStrategy(Map<String, dynamic> strategy) async {
    final jsonString = jsonEncode(strategy);
    await _prefs?.setString('certificateSelectedAIStrategy', jsonString);
    print('💾 Saved Selected Strategy: ${strategy['title']}');
  }

// Get Selected AI Strategy
  static Map<String, dynamic> getCertificateSelectedAIStrategy() {
    final jsonString = _prefs?.getString('certificateSelectedAIStrategy') ?? '{}';
    try {
      final Map<String, dynamic> strategy = jsonDecode(jsonString);
      return strategy;
    } catch (e) {
      print('❌ Error parsing selected strategy: $e');
      return {};
    }
  }

// Clear selected strategy
  static Future<void> clearSelectedStrategy() async {
    await _prefs?.remove('certificateSelectedAIStrategy');
    print('🧹 Cleared selected strategy');
  }


  // Add this to your SharedPrefs class
  static Future<bool> verifyAllCertificateData() async {
    final objective = getCertificateObjective();
    final keyResults = getCertificateKeyResults();
    final initiatives = getCertificateInitiatives();
    final scenario = getCertificateScenario();
    final strategy = getCertificateSelectedAIStrategy();

    print('🔍 VERIFYING ALL CERTIFICATE DATA:');
    print('🎯 Objective: ${objective['title']?.isNotEmpty == true ? "✅" : "❌"} ${objective['title']}');
    print('📊 Key Results: ${keyResults.length >= 3 ? "✅" : "❌"} ${keyResults.length}/3');
    print('🚀 Initiatives: ${initiatives.length >= 2 ? "✅" : "❌"} ${initiatives.length}/2');
    print('📖 Scenario: ${scenario.isNotEmpty ? "✅" : "❌"} ${scenario.length} chars');
    print('🎯 Strategy: ${strategy.isNotEmpty ? "✅" : "❌"} ${strategy['title']}');

    return objective['title']?.isNotEmpty == true &&
        keyResults.length >= 3 &&
        initiatives.length >= 2 &&
        scenario.isNotEmpty &&
        strategy.isNotEmpty;
  }

// Update the printCertificateData method to include strategy
  static void printCertificateData() {
    print('📋 CERTIFICATION DATA SUMMARY:');
    print('🎯 Objective: ${getCertificateObjective()}');
    print('📊 Key Results: ${getCertificateKeyResults().length} items');
    print('🚀 Initiatives: ${getCertificateInitiatives().length} items');
    print('📖 Scenario: ${getCertificateScenario().length} characters');
    print('📋 CERTIFICATION DATA SUMMARY:');
    print('🎯 Objective: ${getCertificateObjective()}');
    print('📊 Key Results: ${getCertificateKeyResults().length} items');
    print('🚀 Initiatives: ${getCertificateInitiatives().length} items');
    print('📖 Scenario: ${getCertificateScenario().length} characters');
    print('🎯 Selected Strategy: ${getCertificateSelectedAIStrategy()['title'] ?? 'None'}');
  }
  // Save Objective
  static Future<void> saveCertificateObjective(String title, String description) async {
    await _prefs?.setString('certificateEnteredObjective_title', title);
    await _prefs?.setString('certificateEnteredObjective_description', description);
    print('💾 Saved Objective: $title');
  }

  // Get Objective
  static Map<String, String> getCertificateObjective() {
    return {
      'title': _prefs?.getString('certificateEnteredObjective_title') ?? '',
      'description': _prefs?.getString('certificateEnteredObjective_description') ?? '',
    };
  }

  // Save Key Results (as JSON string)
  static Future<void> saveCertificateKeyResults(List<Map<String, String>> keyResults) async {
    final jsonString = jsonEncode(keyResults);
    await _prefs?.setString('certificateEnteredKeyResults', jsonString);
    print('💾 Saved ${keyResults.length} Key Results');
  }

  // Get Key Results
  static List<Map<String, String>> getCertificateKeyResults() {
    final jsonString = _prefs?.getString('certificateEnteredKeyResults') ?? '[]';
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => Map<String, String>.from(item)).toList();
    } catch (e) {
      print('❌ Error parsing key results: $e');
      return [];
    }
  }

  // Save Initiatives (as JSON string)
  static Future<void> saveCertificateInitiatives(List<Map<String, String>> initiatives) async {
    final jsonString = jsonEncode(initiatives);
    await _prefs?.setString('certificateEnteredInitiatives', jsonString);
    print('💾 Saved ${initiatives.length} Initiatives');
  }

  // Get Initiatives
  static List<Map<String, String>> getCertificateInitiatives() {
    final jsonString = _prefs?.getString('certificateEnteredInitiatives') ?? '[]';
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => Map<String, String>.from(item)).toList();
    } catch (e) {
      print('❌ Error parsing initiatives: $e');
      return [];
    }
  }

  // Save Scenario
  static Future<void> saveCertificateScenario(String scenario) async {
    await _prefs?.setString('certificateScenario', scenario);
    print('💾 Saved Scenario: ${scenario.length} characters');
  }

  // Get Scenario
  static String getCertificateScenario() {
    return _prefs?.getString('certificateScenario') ??
        'A multinational technology company facing declining market share and internal coordination challenges across 3 departments: Sales, Product, and Operations.';
  }

  // Clear all certification data
  static Future<void> clearCertificateData() async {
    await _prefs?.remove('certificateEnteredObjective_title');
    await _prefs?.remove('certificateEnteredObjective_description');
    await _prefs?.remove('certificateEnteredKeyResults');
    await _prefs?.remove('certificateEnteredInitiatives');
    await _prefs?.remove('certificateScenario');
    print('🧹 Cleared all certificate data');
  }

  // Check if certification data exists
  static bool hasCertificateData() {
    return getCertificateObjective()['title']?.isNotEmpty == true &&
        getCertificateKeyResults().isNotEmpty &&
        getCertificateInitiatives().isNotEmpty;
  }


  // ===========================================================================
  // 🔹 MISSION & INITIATIVES
  // ===========================================================================

  static const String keyMissionDescription = 'mission_description';
  static const String keyFirstInitiativeTitle = 'first_initiative_title';
  static const String keyFirstInitiativeDesc = 'first_initiative_desc';
  static const String keySecondInitiativeTitle = 'second_initiative_title';
  static const String keySecondInitiativeDesc = 'second_initiative_desc';

  static Future<void> saveMissionDescription(String description) async {
    await _prefs?.setString(keyMissionDescription, description);
  }

  static String? getMissionDescription() {
    return _prefs?.getString(keyMissionDescription);
  }

  static Future<void> clearMissionDescription() async {
    await _prefs?.remove(keyMissionDescription);
  }

  static Future<void> saveInitiatives({
    required String firstTitle,
    required String firstDesc,
    required String secondTitle,
    required String secondDesc,
  }) async {
    await _prefs?.setString(keyFirstInitiativeTitle, firstTitle);
    await _prefs?.setString(keyFirstInitiativeDesc, firstDesc);
    await _prefs?.setString(keySecondInitiativeTitle, secondTitle);
    await _prefs?.setString(keySecondInitiativeDesc, secondDesc);
  }

  static Map<String, String> getInitiatives() {
    return {
      'firstTitle': _prefs?.getString(keyFirstInitiativeTitle) ?? '',
      'firstDesc': _prefs?.getString(keyFirstInitiativeDesc) ?? '',
      'secondTitle': _prefs?.getString(keySecondInitiativeTitle) ?? '',
      'secondDesc': _prefs?.getString(keySecondInitiativeDesc) ?? '',
    };
  }

  static Future<void> clearInitiatives() async {
    await _prefs?.remove(keyFirstInitiativeTitle);
    await _prefs?.remove(keyFirstInitiativeDesc);
    await _prefs?.remove(keySecondInitiativeTitle);
    await _prefs?.remove(keySecondInitiativeDesc);
  }

  // ===========================================================================
  // 🔹 ADAPTATION DATA
  // ===========================================================================

  static const String keyRevisedKeyResult = 'revised_key_result';
  static const String keyStrategicActions = 'strategic_actions';
  static const String keyAdaptationNotes = 'adaptation_notes';

  static Future<void> saveAdaptationData({
    required String revisedKeyResult,
    required String strategicActions,
    String adaptationNotes = '',
  }) async {
    await _prefs?.setString(keyRevisedKeyResult, revisedKeyResult);
    await _prefs?.setString(keyStrategicActions, strategicActions);
    await _prefs?.setString(keyAdaptationNotes, adaptationNotes);
  }

  static Map<String, String> getAdaptationData() {
    return {
      'revisedKeyResult': _prefs?.getString(keyRevisedKeyResult) ?? '',
      'strategicActions': _prefs?.getString(keyStrategicActions) ?? '',
      'adaptationNotes': _prefs?.getString(keyAdaptationNotes) ?? '',
    };
  }

  static Future<void> clearAdaptationData() async {
    await _prefs?.remove(keyRevisedKeyResult);
    await _prefs?.remove(keyStrategicActions);
    await _prefs?.remove(keyAdaptationNotes);
  }

  // ===========================================================================
  // 🔹 EVALUATION & RESULTS
  // ===========================================================================

  static const String keyFinalOkrEvaluationResult = 'final_okr_evaluation_result';
  static const String keyChallengeEvaluationResult = 'challenge_evaluation_result';
  static const String keyEvaluationScore = 'evaluation_score';
  static const String keyEvaluationDecision = 'evaluation_decision';
  static const String keyEvaluationExplanation = 'evaluation_explanation';
  static const String keyChallengeResults = 'challenge_results';
  static const String keyCurrentChallengeData = 'current_challenge_data';

  static Future<void> saveFinalOkrEvaluationResult(Map<String, dynamic> result) async {
    final jsonString = jsonEncode(result);
    await _prefs?.setString(keyFinalOkrEvaluationResult, jsonString);
  }

  static Map<String, dynamic>? getFinalOkrEvaluationResult() {
    final jsonString = _prefs?.getString(keyFinalOkrEvaluationResult);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveChallengeEvaluationResult(Map<String, dynamic> result) async {
    final jsonString = jsonEncode(result);
    await _prefs?.setString(keyChallengeEvaluationResult, jsonString);
  }

  static Map<String, dynamic>? getChallengeEvaluationResult() {
    final jsonString = _prefs?.getString(keyChallengeEvaluationResult);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveEvaluationSummary({
    required int score,
    required String decision,
    required String explanation,
  }) async {
    await _prefs?.setInt(keyEvaluationScore, score);
    await _prefs?.setString(keyEvaluationDecision, decision);
    await _prefs?.setString(keyEvaluationExplanation, explanation);
  }

  static Map<String, dynamic> getEvaluationSummary() {
    return {
      'score': _prefs?.getInt(keyEvaluationScore) ?? 0,
      'decision': _prefs?.getString(keyEvaluationDecision) ?? 'Pending',
      'explanation': _prefs?.getString(keyEvaluationExplanation) ?? 'No analysis available',
    };
  }

  static Future<void> saveChallengeResults(List<Map<String, dynamic>> results) async {
    await _prefs?.setString(keyChallengeResults, jsonEncode(results));
  }

  static Future<List<Map<String, dynamic>>?> getChallengeResults() async {
    final resultsJson = _prefs?.getString(keyChallengeResults);
    if (resultsJson == null) return null;

    try {
      final List<dynamic> resultsList = jsonDecode(resultsJson);
      return resultsList.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      print('❌ Error parsing challenge results: $e');
      return null;
    }
  }

  static Future<void> saveCurrentChallengeData(Map<String, dynamic> data) async {
    await _prefs?.setString(keyCurrentChallengeData, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getCurrentChallengeData() async {
    final dataJson = _prefs?.getString(keyCurrentChallengeData);
    if (dataJson == null) return null;

    try {
      return Map<String, dynamic>.from(jsonDecode(dataJson));
    } catch (e) {
      print('❌ Error parsing current challenge data: $e');
      return null;
    }
  }

  static Future<void> clearEvaluationData() async {
    await _prefs?.remove(keyFinalOkrEvaluationResult);
    await _prefs?.remove(keyChallengeEvaluationResult);
    await _prefs?.remove(keyEvaluationScore);
    await _prefs?.remove(keyEvaluationDecision);
    await _prefs?.remove(keyEvaluationExplanation);
  }

  // ===========================================================================
  // 🔹 ICON CONVERSION HELPERS
  // ===========================================================================

  static String _iconToString(IconData? icon) {
    if (icon == Icons.computer) return 'computer';
    if (icon == Icons.account_balance) return 'finance';
    if (icon == Icons.local_hospital) return 'health';
    if (icon == Icons.flash_on) return 'energy';
    if (icon == Icons.local_shipping) return 'logistics';
    if (icon == Icons.account_balance_outlined) return 'public';
    if (icon == Icons.storefront) return 'retail';
    if (icon == Icons.phone_android) return 'telecom';
    if (icon == Icons.agriculture) return 'agriculture';
    return 'default';
  }

  static IconData _stringToIcon(String? iconName) {
    switch (iconName) {
      case 'computer':
        return Icons.computer;
      case 'finance':
        return Icons.account_balance;
      case 'health':
        return Icons.local_hospital;
      case 'energy':
        return Icons.flash_on;
      case 'logistics':
        return Icons.local_shipping;
      case 'public':
        return Icons.account_balance_outlined;
      case 'retail':
        return Icons.storefront;
      case 'telecom':
        return Icons.phone_android;
      case 'agriculture':
        return Icons.agriculture;
      default:
        return Icons.work;
    }
  }

  // ===========================================================================
  // 🔹 UTILITY METHODS
  // ===========================================================================

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }

  static bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  static Set<String> getAllKeys() {
    return _prefs?.getKeys() ?? {};
  }

  static Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }
}




// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
//
// /// 🎯 SharedPreferences Wrapper
// /// Centralized storage for all app data
// class SharedPrefs {
//   static SharedPreferences? _prefs;
//
//
//
//   // 🔹 ADAPTATION DATA STORAGE
//   static const String keyRevisedKeyResult = 'revised_key_result';
//   static const String keyStrategicActions = 'strategic_actions';
//   static const String keyAdaptationNotes = 'adaptation_notes';
//
//   // Save adaptation data
//   static Future<void> saveAdaptationData({
//     required String revisedKeyResult,
//     required String strategicActions,
//     String adaptationNotes = '',
//   }) async {
//     await _prefs?.setString(keyRevisedKeyResult, revisedKeyResult);
//     await _prefs?.setString(keyStrategicActions, strategicActions);
//     await _prefs?.setString(keyAdaptationNotes, adaptationNotes);
//   }
//   // 🔹 API RESULTS STORAGE
//   static const String keyFinalOkrEvaluationResult = 'final_okr_evaluation_result';
//   static const String keyChallengeEvaluationResult = 'challenge_evaluation_result';
//   static const String keyEvaluationScore = 'evaluation_score';
//   static const String keyEvaluationDecision = 'evaluation_decision';
//   static const String keyEvaluationExplanation = 'evaluation_explanation';
//
//   // Save Final OKR Evaluation Result (for Solo Mode)
//   static Future<void> saveFinalOkrEvaluationResult(Map<String, dynamic> result) async {
//     final jsonString = jsonEncode(result); // Now this will work with the import
//     await _prefs?.setString(keyFinalOkrEvaluationResult, jsonString);
//   }
//   // Save evaluation summary for quick access
//   static Future<void> saveEvaluationSummary({
//     required int score,
//     required String decision,
//     required String explanation,
//   }) async {
//     await _prefs?.setInt(keyEvaluationScore, score);
//     await _prefs?.setString(keyEvaluationDecision, decision);
//     await _prefs?.setString(keyEvaluationExplanation, explanation);
//   }
//
//   // Get evaluation summary
//   static Map<String, dynamic> getEvaluationSummary() {
//     return {
//       'score': _prefs?.getInt(keyEvaluationScore) ?? 0,
//       'decision': _prefs?.getString(keyEvaluationDecision) ?? 'Pending',
//       'explanation': _prefs?.getString(keyEvaluationExplanation) ?? 'No analysis available',
//     };
//   }
// // Save challenge results
//   static Future<void> saveChallengeResults(List<Map<String, dynamic>> results) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('challenge_results', jsonEncode(results));
//   }
//
//   // Get challenge results
//   // Get challenge results - Make it async
//   static Future<List<Map<String, dynamic>>?> getChallengeResults() async {
//     final prefs = await SharedPreferences.getInstance();
//     final resultsJson = prefs.getString('challenge_results');
//     if (resultsJson == null) return null;
//
//     try {
//       final List<dynamic> resultsList = jsonDecode(resultsJson);
//       return resultsList.map((item) => Map<String, dynamic>.from(item)).toList();
//     } catch (e) {
//       print('❌ Error parsing challenge results: $e');
//       return null;
//     }
//   }
//   // Save current challenge data
//   static Future<void> saveCurrentChallengeData(Map<String, dynamic> data) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('current_challenge_data', jsonEncode(data));
//   }
// // Get current challenge data - Make it async
//   static Future<Map<String, dynamic>?> getCurrentChallengeData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final dataJson = prefs.getString('current_challenge_data');
//     if (dataJson == null) return null;
//
//     try {
//       return Map<String, dynamic>.from(jsonDecode(dataJson));
//     } catch (e) {
//       print('❌ Error parsing current challenge data: $e');
//       return null;
//     }
//   }
//   // Clear all evaluation data
//   static Future<void> clearEvaluationData() async {
//     await _prefs?.remove(keyFinalOkrEvaluationResult);
//     await _prefs?.remove(keyChallengeEvaluationResult);
//     await _prefs?.remove(keyEvaluationScore);
//     await _prefs?.remove(keyEvaluationDecision);
//     await _prefs?.remove(keyEvaluationExplanation);
//   }
//   // Get Final OKR Evaluation Result
//   static Map<String, dynamic>? getFinalOkrEvaluationResult() {
//     final jsonString = _prefs?.getString(keyFinalOkrEvaluationResult);
//     if (jsonString == null) return null;
//     try {
//       return jsonDecode(jsonString); // Now this will work with the import
//     } catch (e) {
//       return null;
//     }
//   }
//
//   // Save Challenge Evaluation Result (for Challenge Mode)
//   static Future<void> saveChallengeEvaluationResult(Map<String, dynamic> result) async {
//     final jsonString = jsonEncode(result); // Now this will work with the import
//     await _prefs?.setString(keyChallengeEvaluationResult, jsonString);
//   }
//
//   // Get Challenge Evaluation Result
//   static Map<String, dynamic>? getChallengeEvaluationResult() {
//     final jsonString = _prefs?.getString(keyChallengeEvaluationResult);
//     if (jsonString == null) return null;
//     try {
//       return jsonDecode(jsonString); // Now this will work with the import
//     } catch (e) {
//       return null;
//     }
//   }
//   // Get adaptation data
//   static Map<String, String> getAdaptationData() {
//     return {
//       'revisedKeyResult': _prefs?.getString(keyRevisedKeyResult) ?? '',
//       'strategicActions': _prefs?.getString(keyStrategicActions) ?? '',
//       'adaptationNotes': _prefs?.getString(keyAdaptationNotes) ?? '',
//     };
//   }
//
//   // Clear adaptation data
//   static Future<void> clearAdaptationData() async {
//     await _prefs?.remove(keyRevisedKeyResult);
//     await _prefs?.remove(keyStrategicActions);
//     await _prefs?.remove(keyAdaptationNotes);
//   }
//
//
//   // ... your existing code ...
//
//   // 🔹 ADD THESE METHODS FOR INITIATIVES STORAGE
//   static const String keyFirstInitiativeTitle = 'first_initiative_title';
//   static const String keyFirstInitiativeDesc = 'first_initiative_desc';
//   static const String keySecondInitiativeTitle = 'second_initiative_title';
//   static const String keySecondInitiativeDesc = 'second_initiative_desc';
//
//   // Save initiatives
//   static Future<void> saveInitiatives({
//     required String firstTitle,
//     required String firstDesc,
//     required String secondTitle,
//     required String secondDesc,
//   }) async {
//     await _prefs?.setString(keyFirstInitiativeTitle, firstTitle);
//     await _prefs?.setString(keyFirstInitiativeDesc, firstDesc);
//     await _prefs?.setString(keySecondInitiativeTitle, secondTitle);
//     await _prefs?.setString(keySecondInitiativeDesc, secondDesc);
//   }
//
//   // Get initiatives
//   static Map<String, String> getInitiatives() {
//     return {
//       'firstTitle': _prefs?.getString(keyFirstInitiativeTitle) ?? '',
//       'firstDesc': _prefs?.getString(keyFirstInitiativeDesc) ?? '',
//       'secondTitle': _prefs?.getString(keySecondInitiativeTitle) ?? '',
//       'secondDesc': _prefs?.getString(keySecondInitiativeDesc) ?? '',
//     };
//   }
//
//   // Clear initiatives
//   static Future<void> clearInitiatives() async {
//     await _prefs?.remove(keyFirstInitiativeTitle);
//     await _prefs?.remove(keyFirstInitiativeDesc);
//     await _prefs?.remove(keySecondInitiativeTitle);
//     await _prefs?.remove(keySecondInitiativeDesc);
//   }
//   /// ✅ Initialize SharedPreferences (call once in main.dart)
//   static Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }
//   static Future<void> saveString(String key, String value) async {
//     await _prefs?.setString(key, value);
//   }
//
//   static Future<String?> getString(String key) async {
//     return _prefs?.getString(key);
//   }
//   // ===========================================================================
//   // 🔹 SECTION 1: USER AUTHENTICATION & PROFILE
//   // ===========================================================================
//
//   static const String keyUserId = 'userId';
//   static const String keyUserName = 'userName';
//   static const String keyUserRole = 'userRole';
//   static const String keySelectedRoleIndex = 'selectedRoleIndex';
//
//   static Future<void> saveGameMode(String gameMode) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('game_mode', gameMode);
//   }
//
//   static Future<String?> getGameMode() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('game_mode');
//   }
//
//   static Future<void> clearGameMode() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('game_mode');
//   }
//
//   /// Save User ID
//   static Future<void> saveUserId(String id) async {
//     await _prefs?.setString(keyUserId, id);
//   }
//
//   /// Get User ID
//   static String? getUserId() {
//     return _prefs?.getString(keyUserId);
//   }
//
//   /// Save User Name
//   static Future<void> saveUserName(String name) async {
//     await _prefs?.setString(keyUserName, name);
//   }
//
//   /// Get User Name
//   static String? getUserName() {
//     return _prefs?.getString(keyUserName);
//   }
//
//   /// Save User Role (e.g., "Product Manager")
//   static Future<void> saveUserRole(String role) async {
//     await _prefs?.setString(keyUserRole, role);
//   }
//
//   /// Get User Role
//   static String? getUserRole() {
//     return _prefs?.getString(keyUserRole);
//   }
//
//   /// Save Selected Role Index
//   static Future<void> saveSelectedRoleIndex(int index) async {
//     await _prefs?.setInt(keySelectedRoleIndex, index);
//   }
//
//   /// Get Selected Role Index (-1 if not set)
//   static int getSelectedRoleIndex() {
//     return _prefs?.getInt(keySelectedRoleIndex) ?? -1;
//   }
//
//   // ===========================================================================
//   // 🔹 SECTION 2: CHALLENGE MANAGEMENT
//   // ===========================================================================
//
//   static const String keyHostId = 'hostId';
//   static const String keyChallengeId = 'challengeId';
//   static const String keyJoinChallengeId = 'joinChallengeId';
//   static const String keyAcceptChallengeId = 'acceptChallengeId';
//   static const String keyAcceptInviteChallengeId = 'acceptInviteChallengeId';
//
//   /// Save Host ID
//   static Future<void> saveHostId(String id) async {
//     await _prefs?.setString(keyHostId, id);
//   }
//
//   /// Get Host ID
//   static String? getHostId() {
//     return _prefs?.getString(keyHostId);
//   }
//
//   /// Save Challenge ID
//   static Future<void> saveChallengeId(String challengeId) async {
//     await _prefs?.setString(keyChallengeId, challengeId);
//   }
//
//   /// Get Challenge ID
//   static Future<String?> getChallengeId() async {
//     return _prefs?.getString(keyChallengeId);
//   }
//
//   /// Save Join Challenge ID
//   static Future<void> saveJoinChallengeId(String challengeId) async {
//     await _prefs?.setString(keyJoinChallengeId, challengeId);
//   }
//
//   /// Get Join Challenge ID
//   static String? getJoinChallengeId() {
//     return _prefs?.getString(keyJoinChallengeId);
//   }
//
//   /// Save Accept Challenge ID
//   static Future<void> saveAcceptChallengeId(String challengeId) async {
//     await _prefs?.setString(keyAcceptChallengeId, challengeId);
//   }
//
//   /// Get Accept Challenge ID
//   static String? getAcceptChallengeId() {
//     return _prefs?.getString(keyAcceptChallengeId);
//   }
//
//   /// Save Accept Invite Challenge ID
//   static Future<void> saveAcceptInviteChallengeId(String challengeId) async {
//     await _prefs?.setString(keyAcceptInviteChallengeId, challengeId);
//   }
//
//   /// Get Accept Invite Challenge ID
//   static String? getAcceptInviteChallengeId() {
//     return _prefs?.getString(keyAcceptInviteChallengeId);
//   }
//
//   // ===========================================================================
//   // 🔹 SECTION 3: INDUSTRY SELECTION
//   // ===========================================================================
//
//   static const String keySelectedIndustryTitle = 'selectedIndustryTitle';
//   static const String keySelectedIndustryDesc = 'selectedIndustryDesc';
//   static const String keySelectedIndustryIcon = 'selectedIndustryIcon';
//
//   /// Save Selected Industry (title, description, icon)
//   static Future<void> saveSelectedIndustry(Map<String, dynamic> industry) async {
//     await _prefs?.setString(
//       keySelectedIndustryTitle,
//       industry['titleKey'].toString(),
//     );
//     await _prefs?.setString(
//       keySelectedIndustryDesc,
//       industry['descriptionKey'].toString(),
//     );
//     await _prefs?.setString(
//       keySelectedIndustryIcon,
//       _iconToString(industry['icon']),
//     );
//   }
//
//   /// Get Selected Industry
//   static Map<String, dynamic>? getSelectedIndustry() {
//     final title = _prefs?.getString(keySelectedIndustryTitle);
//     final desc = _prefs?.getString(keySelectedIndustryDesc);
//     final iconName = _prefs?.getString(keySelectedIndustryIcon);
//
//     if (title == null) return null;
//
//     return {
//       'titleKey': title,
//       'descriptionKey': desc ?? '',
//       'icon': _stringToIcon(iconName),
//     };
//   }
//
//   /// Clear Selected Industry
//   static Future<void> clearSelectedIndustry() async {
//     await _prefs?.remove(keySelectedIndustryTitle);
//     await _prefs?.remove(keySelectedIndustryDesc);
//     await _prefs?.remove(keySelectedIndustryIcon);
//   }
//
//   // ===========================================================================
//   // 🔹 SECTION 4: CAMPAIGN SUGGESTION (AI Generated)
//   // ===========================================================================
//
//   static const String keyCampaignSuggestionName = 'campaignSuggestionName';
//   static const String keyCampaignSuggestionDesc = 'campaignSuggestionDesc';
//
//   /// Save Campaign Suggestion (from AI API)
//   static Future<void> saveCampaignSuggestion(
//       String name,
//       String description,
//       ) async {
//     await _prefs?.setString(keyCampaignSuggestionName, name);
//     await _prefs?.setString(keyCampaignSuggestionDesc, description);
//   }
//
//   /// Get Campaign Suggestion Name
//   static String? getCampaignSuggestionName() {
//     return _prefs?.getString(keyCampaignSuggestionName);
//   }
//
//   /// Get Campaign Suggestion Description
//   static String? getCampaignSuggestionDescription() {
//     return _prefs?.getString(keyCampaignSuggestionDesc);
//   }
//
//   /// Clear Campaign Suggestion
//   static Future<void> clearCampaignSuggestion() async {
//     await _prefs?.remove(keyCampaignSuggestionName);
//     await _prefs?.remove(keyCampaignSuggestionDesc);
//   }
//
//   // ===========================================================================
//   // 🔹 SECTION 5: MISSION DESCRIPTION
//   // ===========================================================================
//
//   static const String keyMissionDescription = 'mission_description';
//
//   /// Save Mission Description
//   static Future<void> saveMissionDescription(String description) async {
//     await _prefs?.setString(keyMissionDescription, description);
//   }
//
//   /// Get Mission Description
//   static String? getMissionDescription() {
//     return _prefs?.getString(keyMissionDescription);
//   }
//
//   /// Clear Mission Description
//   static Future<void> clearMissionDescription() async {
//     await _prefs?.remove(keyMissionDescription);
//   }
//
//   // ===========================================================================
//   // 🔹 SECTION 6: ICON CONVERSION HELPERS (Private)
//   // ===========================================================================
//
//   /// Convert IconData to String for storage
//   static String _iconToString(IconData? icon) {
//     if (icon == Icons.computer) return 'computer';
//     if (icon == Icons.account_balance) return 'finance';
//     if (icon == Icons.local_hospital) return 'health';
//     if (icon == Icons.flash_on) return 'energy';
//     if (icon == Icons.local_shipping) return 'logistics';
//     if (icon == Icons.account_balance_outlined) return 'public';
//     if (icon == Icons.storefront) return 'retail';
//     if (icon == Icons.phone_android) return 'telecom';
//     if (icon == Icons.agriculture) return 'agriculture';
//     return 'default';
//   }
//
//   /// Convert String back to IconData
//   static IconData _stringToIcon(String? iconName) {
//     switch (iconName) {
//       case 'computer':
//         return Icons.computer;
//       case 'finance':
//         return Icons.account_balance;
//       case 'health':
//         return Icons.local_hospital;
//       case 'energy':
//         return Icons.flash_on;
//       case 'logistics':
//         return Icons.local_shipping;
//       case 'public':
//         return Icons.account_balance_outlined;
//       case 'retail':
//         return Icons.storefront;
//       case 'telecom':
//         return Icons.phone_android;
//       case 'agriculture':
//         return Icons.agriculture;
//       default:
//         return Icons.work; // fallback
//     }
//   }
//
//   // ===========================================================================
//   // 🔹 SECTION 7: UTILITY METHODS
//   // ===========================================================================
//
//   /// Clear all stored data
//   static Future<void> clearAll() async {
//     await _prefs?.clear();
//   }
//
//   /// Check if key exists
//   static bool containsKey(String key) {
//     return _prefs?.containsKey(key) ?? false;
//   }
//
//   /// Get all keys (for debugging)
//   static Set<String> getAllKeys() {
//     return _prefs?.getKeys() ?? {};
//   }
// }
