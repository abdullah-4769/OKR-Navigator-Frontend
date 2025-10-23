// // lib/utils/game_mode_manager.dart
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../services/shared_preference.dart';
//
// class GameModeManager {
//   static const String soloMode = 'solo';
//   static const String campaignMode = 'campaign';
//   static const String challengeMode = 'challenge';
//   static const String teamMode = 'team';
//
//   /// Start Solo Mode
//   static Future<void> startSoloMode({
//     required Map<String, dynamic> selectedRole,
//     required Map<String, dynamic> selectedIndustry,
//   }) async {
//     await SharedPrefs.saveGameMode(soloMode, data: {
//       'type': soloMode,
//       'role': selectedRole,
//       'industry': selectedIndustry,
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//     });
//   }
//
//   /// Start Campaign Mode
//   static Future<void> startCampaignMode({
//     required Map<String, dynamic> organization,
//     required Map<String, dynamic> selectedRole,
//     required Map<String, dynamic> selectedIndustry,
//   }) async {
//     await SharedPrefs.saveGameMode(campaignMode, data: {
//       'type': campaignMode,
//       'organization': organization,
//       'role': selectedRole,
//       'industry': selectedIndustry,
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//     });
//   }
//
//   /// Start Challenge Mode
//   static Future<void> startChallengeMode({
//     required Map<String, dynamic> selectedRole,
//     required Map<String, dynamic> selectedIndustry,
//     String? challengeId,
//     Map<String, dynamic>? opponents,
//   }) async {
//     await SharedPrefs.saveGameMode(challengeMode, data: {
//       'type': challengeMode,
//       'role': selectedRole,
//       'industry': selectedIndustry,
//       'challengeId': challengeId,
//       'opponents': opponents,
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//     });
//   }
//
//   /// Get current game mode configuration
//   static Map<String, dynamic>? getCurrentGameConfig() {
//     return SharedPrefs.getGameModeData();
//   }
//
//   /// Check if we're in a specific game mode
//   static bool isMode(String mode) {
//     return SharedPrefs.getGameMode() == mode;
//   }
//
//   /// Clear current game mode
//   static Future<void> clearCurrentMode() async {
//     await SharedPrefs.clearGameMode();
//   }
// }