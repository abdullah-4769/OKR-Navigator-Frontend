// lib/data/repositories/key_result_repository.dart
import 'package:get/get.dart';
import '../../generated/models/key_results/key_results.dart';
import '../../services/key_result/key_results.dart';

class KeyResultRepository extends GetxService {
  final KeyResultService _keyResultService = Get.find<KeyResultService>();

  Future<List<KeyResults>> fetchKeyResults() async {
    try {
      print('🔄 Repository: Fetching...');
      final results = await _keyResultService.getKeyResultsBatch();
      print('✅ Repository: Got ${results.length} key results');
      return results;
    } catch (e) {
      print('❌ Repository Error: $e');
      throw Exception('Repository error: $e');
    }
  }
}