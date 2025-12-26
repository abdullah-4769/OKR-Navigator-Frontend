
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// 🎯 SharedPreferences Wrapper - Complete Version
class SharedPrefs {
  static SharedPreferences? _prefs;
  static const String keyBonusScore = 'bonus_score';
  static const String keyHasSubmittedBonus = 'has_submitted_bonus';

  static Future<void> saveBonusScore(int score) async {
    await _prefs?.setInt(keyBonusScore, score);
    print('💾 Saved bonus score: $score');
  }

  static int getBonusScore() {
    return _prefs?.getInt(keyBonusScore) ?? 0;
  }

  static Future<void> setBonusSubmitted(bool submitted) async {
    await _prefs?.setBool(keyHasSubmittedBonus, submitted);
  }

  static bool getBonusSubmitted() {
    return _prefs?.getBool(keyHasSubmittedBonus) ?? false;
  }

  // Clear bonus data when starting new game
  static Future<void> clearBonusData() async {
    await _prefs?.remove(keyBonusScore);
    await _prefs?.remove(keyHasSubmittedBonus);
    print('🧹 Cleared bonus data');
  }

  /// Initialize SharedPreferences (call once in main.dart)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ===========================================================================
  // 🔹 GAME FLOW MANAGEMENT
  // ===========================================================================

  static Future<void> clearGameFlowData() async {
    print('🧹 Clearing game flow data for fresh start...');

    // Clear key results
    await _prefs?.remove('selected_key_results');

    // Clear initiative data
    await clearInitiatives();

    // Clear adaptation data
    await clearAdaptationData();
    await clearAdaptationAnalysisData();

    // Clear evaluation data
    await clearEvaluationData();

    // Keep these: strategy, objective, role, industry (so user doesn't have to reselect)
    print('✅ Game flow data cleared successfully');
  }

  static Future<void> clearForRetry() async {
    print('🔄 Clearing data for retry...');

    // Clear only the data that needs to be regenerated
    await _prefs?.remove('selected_key_results');
    await clearInitiatives();
    await clearAdaptationData();
    await clearEvaluationData();

    print('✅ Data cleared for retry');
  }

  static Future<void> clearGameSessionData() async {
    print('🧹 Clearing all game session data for fresh start...');

    // Clear strategy selection
    await _prefs?.remove(keySelectedStrategy);

    // Clear objective selection
    await _prefs?.remove(keySelectedObjective);

    // Clear role selection
    await _prefs?.remove(keySelectedRole);
    await _prefs?.remove(keySelectedRoleIndex);

    // Clear industry selection
    await _prefs?.remove(keySelectedIndustryTitle);
    await _prefs?.remove(keySelectedIndustryDesc);
    await _prefs?.remove(keySelectedIndustryIcon);

    // Clear mission & initiatives
    await _prefs?.remove(keyMissionDescription);
    await _prefs?.remove(keyFirstInitiativeTitle);
    await _prefs?.remove(keyFirstInitiativeDesc);
    await _prefs?.remove(keySecondInitiativeTitle);
    await _prefs?.remove(keySecondInitiativeDesc);

    // Clear adaptation data
    await _prefs?.remove(keyRevisedKeyResult);
    await _prefs?.remove(keyStrategicActions);
    await _prefs?.remove(keyAdaptationNotes);
    await clearAdaptationAnalysisData();

    // Clear evaluation data
    await clearEvaluationData();

    // Clear campaign data
    await _prefs?.remove(keyCampaignSuggestionName);
    await _prefs?.remove(keyCampaignSuggestionDesc);
    await _prefs?.remove(keyCampaignScenario);

    // Clear challenge data
    await _prefs?.remove(keyCurrentChallengeData);
    await _prefs?.remove(keyChallengeResults);

    // Keep these: userId, userName, gameMode (so user doesn't have to login again)
    // Keep certification data if you want to preserve certificate progress

    print('✅ Game session data cleared successfully');
  }

  // ===========================================================================
  // 🔹 USER AUTHENTICATION & PROFILE
  // ===========================================================================

  static const String keyUserId = 'userId';
  static const String keyUserName = 'userName';
  static const String keyUserRole = 'userRole';
  static const String keySelectedRoleIndex = 'selectedRoleIndex';

  static Future<void> saveUserId(String id) async {
    await _prefs?.setString(keyUserId, id);
    print('💾 Saved User ID: $id');
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
  // 🔹 CAMPAIGN & STRATEGY
  // ===========================================================================

  static const String keyCorrectStrategyId = 'correct_strategy_id';
  static const String keyCampaignScenario = 'campaign_scenario';
  static const String keyCampaignSuggestionName = 'campaignSuggestionName';
  static const String keyCampaignSuggestionDesc = 'campaignSuggestionDesc';

  static Future<void> saveCorrectStrategyId(int strategyId) async {
    await _prefs?.setInt(keyCorrectStrategyId, strategyId);
  }

  static int getCorrectStrategyId() {
    return _prefs?.getInt(keyCorrectStrategyId) ?? 0;
  }

  static Future<void> saveCampaignScenario(String scenario) async {
    await _prefs?.setString(keyCampaignScenario, scenario);
  }

  static String? getCampaignScenario() {
    return _prefs?.getString(keyCampaignScenario);
  }

  static Future<void> saveCampaignSuggestion(String name, String description) async {
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

  // ===========================================================================
  // 🔹 CERTIFICATION DATA (KEEPING OLD WORKING VERSION)
  // ===========================================================================

  static Future<void> saveCertificationEvaluationResult(Map<String, dynamic> result) async {
    final jsonString = jsonEncode(result);
    await _prefs?.setString('certification_evaluation_result', jsonString);
    print('💾 Saved certification evaluation result');
  }

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

  static Future<void> clearCertificationEvaluationResult() async {
    await _prefs?.remove('certification_evaluation_result');
    print('🧹 Cleared certification evaluation result');
  }

  static Future<void> saveCertificateSelectedAIStrategy(Map<String, dynamic> strategy) async {
    final jsonString = jsonEncode(strategy);
    await _prefs?.setString('certificateSelectedAIStrategy', jsonString);
    print('💾 Saved Selected Strategy: ${strategy['title']}');
  }

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

  // ===========================================================================
  // 🔹 CERTIFICATE DATA VERIFICATION & DEBUGGING (FROM CURRENT CODE)
  // ===========================================================================

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

  static void printCertificateData() {
    print('📋 CERTIFICATION DATA SUMMARY:');
    print('🎯 Objective: ${getCertificateObjective()}');
    print('📊 Key Results: ${getCertificateKeyResults().length} items');
    print('🚀 Initiatives: ${getCertificateInitiatives().length} items');
    print('📖 Scenario: ${getCertificateScenario().length} characters');
    print('🎯 Selected Strategy: ${getCertificateSelectedAIStrategy()['title'] ?? 'None'}');
  }

  // Add this to your SharedPrefs class for debugging
  static void debugCertificateData() {
    print('🔍 DEBUG CERTIFICATE DATA:');
    final jsonString = _prefs?.getString('certificateEnteredKeyResults');
    print('   - Raw JSON: $jsonString');

    if (jsonString != null) {
      try {
        final decoded = json.decode(jsonString);
        print('   - Decoded: $decoded');
        print('   - Type: ${decoded.runtimeType}');
      } catch (e) {
        print('   - Decode error: $e');
      }
    }
  }

  // ===========================================================================
  // 🔹 CERTIFICATE CORE METHODS (KEEPING OLD WORKING VERSION)
  // ===========================================================================

  static Future<void> saveCertificateObjective(String title, String description) async {
    await _prefs?.setString('certificateEnteredObjective_title', title);
    await _prefs?.setString('certificateEnteredObjective_description', description);
    print('💾 Saved Objective: $title');
  }

  static Map<String, String> getCertificateObjective() {
    return {
      'title': _prefs?.getString('certificateEnteredObjective_title') ?? '',
      'description': _prefs?.getString('certificateEnteredObjective_description') ?? '',
    };
  }

  // KEEPING THE OLD WORKING VERSION - SIMPLE AND RELIABLE
  static Future<void> saveCertificateKeyResults(List<Map<String, String>> keyResults) async {
    final jsonString = jsonEncode(keyResults);
    await _prefs?.setString('certificateEnteredKeyResults', jsonString);
    print('💾 Saved ${keyResults.length} Key Results');
  }

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

  static Future<void> saveCertificateInitiatives(List<Map<String, String>> initiatives) async {
    final jsonString = jsonEncode(initiatives);
    await _prefs?.setString('certificateEnteredInitiatives', jsonString);
    print('💾 Saved ${initiatives.length} Initiatives');
  }

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

  static Future<void> saveCertificateScenario(String scenario) async {
    await _prefs?.setString('certificateScenario', scenario);
    print('💾 Saved Scenario: ${scenario.length} characters');
  }

  static String getCertificateScenario() {
    return _prefs?.getString('certificateScenario') ??
        'A multinational technology company facing declining market share and internal coordination challenges across 3 departments: Sales, Product, and Operations.';
  }

  static Future<void> clearCertificateData() async {
    await _prefs?.remove('certificateEnteredObjective_title');
    await _prefs?.remove('certificateEnteredObjective_description');
    await _prefs?.remove('certificateEnteredKeyResults');
    await _prefs?.remove('certificateEnteredInitiatives');
    await _prefs?.remove('certificateScenario');
    await _prefs?.remove('certificateSelectedAIStrategy');
    print('🧹 Cleared all certificate data');
  }

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
  static const String keyAdaptationAnalysisData = 'adaptation_analysis_data';

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

  static Future<void> saveAdaptationAnalysisData(Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      await _prefs?.setString(keyAdaptationAnalysisData, jsonString);
      print('💾 Saved adaptation analysis data');
    } catch (e) {
      print('❌ Error saving adaptation analysis data: $e');
    }
  }

  static Future<Map<String, dynamic>?> getAdaptationAnalysisData() async {
    try {
      final jsonString = _prefs?.getString(keyAdaptationAnalysisData);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('❌ Error getting adaptation analysis data: $e');
      return null;
    }
  }

  static Future<void> clearAdaptationAnalysisData() async {
    await _prefs?.remove(keyAdaptationAnalysisData);
    print('🧹 Cleared adaptation analysis data');
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
    await _prefs?.remove(keyChallengeResults);
    await _prefs?.remove(keyCurrentChallengeData);
  }

  // ===========================================================================
  // 🔹 STRATEGY & OBJECTIVE SELECTION
  // ===========================================================================

  static const String keySelectedStrategy = 'selectedStrategy';
  static const String keySelectedObjective = 'selectedObjective';
  static const String keySelectedRole = 'selectedRole';

  static Future<void> saveSelectedStrategy(Map<String, dynamic> strategy) async {
    final jsonString = jsonEncode(strategy);
    await _prefs?.setString(keySelectedStrategy, jsonString);
    print('💾 Saved Selected Strategy: ${strategy['title']}');
  }

  static Future<Map<String, dynamic>?> getSelectedStrategy() async {
    final jsonString = _prefs?.getString(keySelectedStrategy);
    if (jsonString == null) return null;
    try {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    } catch (e) {
      print('❌ Error parsing selected strategy: $e');
      return null;
    }
  }

  static Future<void> clearSelectedStrategy() async {
    await _prefs?.remove(keySelectedStrategy);
    print('🧹 Cleared selected strategy');
  }

  static Future<void> saveSelectedObjective(Map<String, dynamic> objective) async {
    final jsonString = jsonEncode(objective);
    await _prefs?.setString(keySelectedObjective, jsonString);
    print('💾 Saved Selected Objective: ${objective['title']}');
  }

  static Future<Map<String, dynamic>?> getSelectedObjective() async {
    final jsonString = _prefs?.getString(keySelectedObjective);
    if (jsonString == null) return null;
    try {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    } catch (e) {
      print('❌ Error parsing selected objective: $e');
      return null;
    }
  }

  static Future<void> clearSelectedObjective() async {
    await _prefs?.remove(keySelectedObjective);
    print('🧹 Cleared selected objective');
  }

  static Future<void> saveSelectedRole(Map<String, dynamic> role) async {
    final jsonString = jsonEncode(role);
    await _prefs?.setString(keySelectedRole, jsonString);
    print('💾 Saved Selected Role: ${role['titleKey']}');
  }

  static Future<Map<String, dynamic>?> getSelectedRole() async {
    final jsonString = _prefs?.getString(keySelectedRole);
    if (jsonString == null) return null;
    try {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    } catch (e) {
      print('❌ Error parsing selected role: $e');
      return null;
    }
  }

  static Future<void> clearSelectedRole() async {
    await _prefs?.remove(keySelectedRole);
    print('🧹 Cleared selected role');
  }

  // ===========================================================================
  // 🔹 UTILITY METHODS
  // ===========================================================================

  static Future<void> clearAll() async {
    await _prefs?.clear();
    print('🧹 Cleared all SharedPreferences data');
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

  static Future<void> saveInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static int getInt(String key, [int defaultValue = 0]) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  static Future<void> saveBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static bool getBool(String key, [bool defaultValue = false]) {
    return _prefs?.getBool(key) ?? defaultValue;
  }
  // ============= LANGUAGE PREFERENCE =============
  static const String keyLanguagePreference = 'language_preference';

  /// Save user's language preference
  static Future<void> saveLanguagePreference(String languageCode) async {
    await _prefs?.setString(keyLanguagePreference, languageCode);
    print('💾 Saved language preference: $languageCode');
  }

  /// Get user's saved language preference
  static String getLanguagePreference() {
    return _prefs?.getString(keyLanguagePreference) ?? 'en';
  }

  /// Clear language preference
  static Future<void> clearLanguagePreference() async {
    await _prefs?.remove(keyLanguagePreference);
    print('🧹 Cleared language preference');
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
}
