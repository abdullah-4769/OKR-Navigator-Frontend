// lib/services/campaign_progress_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class CampaignProgressService {
  static const String _keyCampaignProgress = 'campaign_progress';
  static const String _keyCurrentLevel = 'campaign_current_level';
  static const String _keyLevel1Completed = 'campaign_level1_completed';
  static const String _keyLevel2Completed = 'campaign_level2_completed';
  static const String _keyLevel3Completed = 'campaign_level3_completed';

  // Initialize campaign progress
  static Future<void> initializeCampaign() async {
    final prefs = await SharedPreferences.getInstance();

    // Only initialize if not already set
    if (!prefs.containsKey(_keyCurrentLevel)) {
      await prefs.setInt(_keyCurrentLevel, 1); // Start at level 1
      await prefs.setBool(_keyLevel1Completed, false);
      await prefs.setBool(_keyLevel2Completed, false);
      await prefs.setBool(_keyLevel3Completed, false);
      print('🎮 Campaign initialized: Level 1');
    }
  }

  // Get current level
  static Future<int> getCurrentLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCurrentLevel) ?? 1;
  }

  // Check if level is completed
  static Future<bool> isLevelCompleted(int level) async {
    final prefs = await SharedPreferences.getInstance();
    switch (level) {
      case 1:
        return prefs.getBool(_keyLevel1Completed) ?? false;
      case 2:
        return prefs.getBool(_keyLevel2Completed) ?? false;
      case 3:
        return prefs.getBool(_keyLevel3Completed) ?? false;
      default:
        return false;
    }
  }

  // Check if level is unlocked
  static Future<bool> isLevelUnlocked(int level) async {
    if (level == 1) return true; // Level 1 is always unlocked

    final currentLevel = await getCurrentLevel();
    return level <= currentLevel;
  }

  // In CampaignProgressService, enhance the completeLevel method:
  static Future<void> completeLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();

    switch (level) {
      case 1:
        await prefs.setBool(_keyLevel1Completed, true);
        await prefs.setInt(_keyCurrentLevel, 2); // Unlock level 2
        print('✅ Level 1 completed! Level 2 unlocked');
        break;
      case 2:
        await prefs.setBool(_keyLevel2Completed, true);
        await prefs.setInt(_keyCurrentLevel, 3); // Unlock level 3
        print('✅ Level 2 completed! Level 3 unlocked');
        break;
      case 3:
        await prefs.setBool(_keyLevel3Completed, true);
        // Don't change currentLevel for level 3 completion
        print('🎉 Level 3 completed! Campaign finished!');
        break;
    }
  }

// Add a method to specifically unlock level 3
  static Future<void> unlockLevel3() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCurrentLevel, 3);
    print('🔓 Level 3 unlocked!');
  }
  //
  // // Mark level as completed and unlock next level
  // static Future<void> completeLevel(int level) async {
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   // Mark current level as completed
  //   switch (level) {
  //     case 1:
  //       await prefs.setBool(_keyLevel1Completed, true);
  //       await prefs.setInt(_keyCurrentLevel, 2); // Unlock level 2
  //       print('✅ Level 1 completed! Level 2 unlocked');
  //       break;
  //     case 2:
  //       await prefs.setBool(_keyLevel2Completed, true);
  //       await prefs.setInt(_keyCurrentLevel, 3); // Unlock level 3
  //       print('✅ Level 2 completed! Level 3 unlocked');
  //       break;
  //     case 3:
  //       await prefs.setBool(_keyLevel3Completed, true);
  //       print('🎉 Level 3 completed! Campaign finished!');
  //       break;
  //   }
  // }

  // Reset campaign progress
  static Future<void> resetCampaign() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCurrentLevel, 1);
    await prefs.setBool(_keyLevel1Completed, false);
    await prefs.setBool(_keyLevel2Completed, false);
    await prefs.setBool(_keyLevel3Completed, false);
    print('🔄 Campaign progress reset');
  }

  // Get completion status for all levels
  static Future<Map<String, dynamic>> getCampaignStatus() async {
    return {
      'currentLevel': await getCurrentLevel(),
      'level1Completed': await isLevelCompleted(1),
      'level2Completed': await isLevelCompleted(2),
      'level3Completed': await isLevelCompleted(3),
      'level1Unlocked': await isLevelUnlocked(1),
      'level2Unlocked': await isLevelUnlocked(2),
      'level3Unlocked': await isLevelUnlocked(3),
    };
  }
}