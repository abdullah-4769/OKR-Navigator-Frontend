// lib/data/datasources/innovative_strategies_api.dart

import 'package:game_app/data/network/app_url.dart';
import 'package:get/get.dart';
import '../../generated/models/responses/contexual_challenge/innovation_model.dart';
import '../../generated/network.dart';

class InnovativeStrategiesApi {
  final DioClient _dioClient = Get.find<DioClient>();

  Future<List<InnovativeStrategiesResponse>> getInnovativeStrategies(int strategyId) async {
    try {
      final response = await _dioClient.dio.get(
        '${AppUrls.keyWordbaseinnovative}$strategyId',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          return data.map((item) => InnovativeStrategiesResponse.fromJson(item)).toList();
        } else {
          throw Exception('Expected list response');
        }
      } else {
        throw Exception('Failed to load innovative strategies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load innovative strategies: $e');
    }
  }
}