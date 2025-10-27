// lib/view_model/innovative_strategies_view_model.dart

import 'package:get/get.dart';
import '../../data/repositories/innovative_repo.dart';
import '../../generated/models/responses/contexual_challenge/innovation_model.dart';

class InnovativeStrategiesViewModel extends GetxController {
  final InnovativeStrategiesRepository _repository = InnovativeStrategiesRepository();

  var isLoading = false.obs;
  var innovativeStrategies = RxList<InnovativeStrategy>();
  var errorMessage = ''.obs;

  Future<void> fetchInnovativeStrategies(int strategyId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getInnovativeStrategies(strategyId);

      if (response.data != null) {
        innovativeStrategies.assignAll(response.data!);
      } else {
        throw Exception('No data received');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load innovative strategies');
    } finally {
      isLoading.value = false;
    }
  }

  void clearData() {
    innovativeStrategies.clear();
    errorMessage.value = '';
  }
}