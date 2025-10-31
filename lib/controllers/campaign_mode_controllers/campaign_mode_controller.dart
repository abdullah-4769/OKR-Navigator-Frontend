import 'package:get/get.dart';

class CampaignModeController extends GetxController {
  var selectedMode = ''.obs;

  void selectMode(String mode) {
    selectedMode.value = mode;
  }

  void startCampaign() {
    if (selectedMode.isNotEmpty) {
      // TODO: Navigate to campaign gameplay screen
      print("Starting campaign in $selectedMode mode...");
    } else {
      Get.snackbar("Select Mode", "Please select a campaign mode first");
    }
  }
}
