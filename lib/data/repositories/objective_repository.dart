import 'package:game_app/data/datasources/strategy_api.dart';

import '../../generated/models/responses/objectives/objectives_response.dart';
import '../../generated/network.dart';

class ObjectiveRepository {
  final _strategyApi = StrategyApi(dio);

  Future<List<Objective>> generateObjectives({
    required int strategyId,
    required String strategy,
    required String role,
    required String industry,
    required String language,
  }) async {
    final response = await _strategyApi.generateObjectives({
      'strategyId': strategyId,
      'strategy': strategy,
      'role': role,
      'industry': industry,
      'language': language,
    });
    if (response.statusCode != null && response.statusCode != 200) {
      throw Exception(response.message ?? 'Could not generate objectives');
    }
    return response.objectives ?? [];
  }
}
