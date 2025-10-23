// lib/data/repositories/innovative_strategy_repo.dart
import 'package:get/get.dart';
import '../../generated/models/responses/contexual_challenge/innovation_model.dart';
import '../datasources/innovative.dart';

class InnovativeStrategiesRepository extends GetxService {
  late final InnovativeStrategiesApi _api;

  InnovativeStrategiesRepository() {
    _api = InnovativeStrategiesApi();
  }

  // ✅ Accept dynamic raw data from API
  Future<List<InnovativeStrategy>> getInnovativeStrategies(int strategyId) async {
    print('🚀 Repository fetching strategies for ID: $strategyId');

    try {
      // Get raw data from API
      final rawData = await _api.getInnovativeStrategies(strategyId);

      print('🔍 Raw data type: ${rawData.runtimeType}');

      // Handle different response formats
      final strategies = _parseRawData(rawData);

      print('✅ Repository received ${strategies.length} strategies');

      // Debug each strategy
      for (var i = 0; i < strategies.length; i++) {
        final strategy = strategies[i];
        print('   Strategy $i:');
        print('      ID: ${strategy.id}');
        print('      Strategy ID: ${strategy.strategyId}');
        print('      Key Result: "${strategy.keyResult}"');
        print('      First: "${strategy.firstInnovative?.title}"');
        print('      Second: "${strategy.secondInnovative?.title}"');
        print('      Third: "${strategy.thirdInnovative?.title}"');
      }

      return strategies;
    } catch (e) {
      print('❌ Repository error: $e');
      rethrow;
    }
  }

  List<InnovativeStrategy> _parseRawData(dynamic rawData) {
    List<InnovativeStrategy> strategies = [];

    if (rawData is List) {
      // Direct list of strategy objects (your actual case)
      for (var item in rawData) {
        if (item is Map<String, dynamic>) {
          strategies.add(_parseStrategy(item));
        }
      }
    } else if (rawData is Map<String, dynamic>) {
      // Single strategy or wrapper object
      if (rawData.containsKey('data')) {
        // Handle wrapper with 'data' field
        final data = rawData['data'];
        if (data is List) {
          strategies = data.map((item) => _parseStrategy(item as Map<String, dynamic>)).toList();
        } else if (data is Map<String, dynamic>) {
          strategies = [_parseStrategy(data)];
        }
      } else {
        // Direct strategy object
        strategies = [_parseStrategy(rawData)];
      }
    }

    return strategies;
  }

  InnovativeStrategy _parseStrategy(Map<String, dynamic> json) {
    print('🔍 Parsing strategy JSON: ${json['id']}, keyResult: ${json['keyResult']}');

    try {
      final strategy = InnovativeStrategy(
        id: (json['id'] as num?)?.toInt() ?? 0,
        strategyId: (json['strategyId'] as num?)?.toInt() ?? 0,
        keyResult: json['keyResult'] as String? ?? '',
        firstInnovative: _parseInnovativeItem(json['firstInnovative']),
        secondInnovative: _parseInnovativeItem(json['secondInnovative']),
        thirdInnovative: _parseInnovativeItem(json['thirdInnovative']),
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
      );

      print('✅ Successfully parsed: ${strategy.keyResult}');
      return strategy;
    } catch (e) {
      print('❌ Error parsing strategy: $e');
      print('❌ JSON data: $json');
      // Return a default strategy instead of rethrowing to prevent crashes
      return InnovativeStrategy(
        id: 0,
        strategyId: 0,
        keyResult: 'Error parsing strategy',
        firstInnovative: null,
        secondInnovative: null,
        thirdInnovative: null,
      );
    }
  }

  InnovativeItem? _parseInnovativeItem(dynamic itemData) {
    print('🔍 Parsing innovative item: $itemData');

    if (itemData == null) {
      print('ℹ️ Innovative item is null');
      return null;
    }

    if (itemData is! Map<String, dynamic>) {
      print('❌ Innovative item is not Map: ${itemData.runtimeType}');
      return null;
    }

    try {
      final item = InnovativeItem(
        title: itemData['title'] as String? ?? '',
        description: itemData['description'] as String? ?? '',
      );

      print('✅ Parsed innovative item: ${item.title}');
      return item;
    } catch (e) {
      print('❌ Error parsing InnovativeItem: $e');
      return null;
    }
  }
}