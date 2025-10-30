import 'package:get/get.dart';

import '../../controllers/journey_controller.dart';
import '../../generated/models/responses/key_results_model/key_results_model.dart';
import '../../services/key_results_service.dart';

class KeyResultsViewModel extends GetxController {
  final ApiService _apiService = ApiService();
  final RxBool loading = false.obs;
  final RxList<KeyResults> keyResults = <KeyResults>[].obs;
  final RxList<KeyResults> selectedKeyResults = <KeyResults>[].obs;
  final RxInt requiredCount = 3.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKeyResults();
  }

  Future<void> fetchKeyResults() async {
    try {
      loading.value = true;
// Example: Get strategy, objective, role from JourneyController or other source
      final journeyController = Get.find<JourneyController>();
// Replace with actual logic to get these values
      final strategy = 'sample_strategy'; // Update based on actual data
      final objective = 'sample_objective'; // Update based on actual data
      final role = 'sample_role'; // Update based on actual data

      final keyResultModel = await _apiService.fetchKeyResults(
        strategy: strategy,
        objective: objective,
        role: role,
      );
      keyResults.assignAll(keyResultModel.keyResults ?? []);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load key results: $e');
    } finally {
      loading.value = false;
    }
  }

  bool isSelected(KeyResults item) {
    return selectedKeyResults.contains(item);
  }

  void toggleSelection(KeyResults item) {
    if (isSelected(item)) {
      selectedKeyResults.remove(item);
    } else if (selectedKeyResults.length < requiredCount.value) {
      selectedKeyResults.add(item);
    } else {
      Get.snackbar('Limit Reached', 'You can only select ${requiredCount.value} key results');
    }
  }

  int get selectedCount => selectedKeyResults.length;
}
