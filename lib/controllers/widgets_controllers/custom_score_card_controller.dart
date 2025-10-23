// custom_score_card_controller.dart
import 'package:get/get.dart';

class CustomScoreCardController extends GetxController {
  final RxInt score = 0.obs;
  final RxString title = "".obs;
  final RxString description = "".obs;

  void setScore(int newScore) => score.value = newScore;
  void setTitle(String newTitle) => title.value = newTitle;
  void setDescription(String newDesc) => description.value = newDesc;
}
