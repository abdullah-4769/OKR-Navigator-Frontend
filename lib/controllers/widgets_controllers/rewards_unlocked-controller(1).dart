import 'package:get/get.dart';

class RewardsUnlockedController extends GetxController {
  final RxList<String> badges = <String>[].obs;
  final RxList<String> titles = <String>[].obs;
  final RxString trophy = "".obs;

  void setBadges(List<String> newBadges) => badges.assignAll(newBadges);
  void setTitles(List<String> newTitles) => titles.assignAll(newTitles);
  void setTrophy(String newTrophy) => trophy.value = newTrophy;
}
