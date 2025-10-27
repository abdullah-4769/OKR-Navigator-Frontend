// lib/repositories/innovative_strategies_repository.dart

import 'package:get/get.dart';

import '../../generated/models/responses/contexual_challenge/innovation_model.dart';
import '../../generated/network.dart';
import '../datasources/innovative.dart';


class InnovativeStrategiesRepository {
  final InnovativeStrategiesApi _innovativeStrategiesApi = InnovativeStrategiesApi(dio);

  Future<InnovativeStrategiesResponse> getInnovativeStrategies(int strategyId) async {
    try {
      final response = await _innovativeStrategiesApi.getInnovativeStrategies(strategyId);

      if (response.statusCode != 200) {
        throw Exception(response.message ?? 'Failed to load innovative strategies');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to fetch innovative strategies: $e');
    }
  }
}