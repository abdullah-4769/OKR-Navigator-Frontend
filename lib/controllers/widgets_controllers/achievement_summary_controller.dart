import 'package:get/get.dart';

class AchievementSummaryController extends GetxController {
  final RxList<String> achievements = <String>[].obs;

  void setAchievements(List<String> newAchievements) {
    achievements.assignAll(newAchievements);
  }
}
