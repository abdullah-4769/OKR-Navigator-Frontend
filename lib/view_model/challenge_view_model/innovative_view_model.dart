// lib/view_model/challenge_view_model/innovative_view_model.dart
import 'package:get/get.dart';
import '../../data/repositories/innovative_strategy_repo.dart';
import '../../generated/models/responses/contexual_challenge/innovation_model.dart';

class InnovativeStrategiesViewModel extends GetxController {
  late final InnovativeStrategiesRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<InnovativeStrategiesRepository>();
  }

  var isLoading = false.obs;
  var innovativeStrategies = <InnovativeStrategy>[].obs;
  var errorMessage = ''.obs;

  Future<void> fetchInnovativeStrategies(int strategyId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final strategies = await _repository.getInnovativeStrategies(strategyId);
      innovativeStrategies.assignAll(strategies);

    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load innovative strategies: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearData() {
    innovativeStrategies.clear();
    errorMessage.value = '';
  }
}