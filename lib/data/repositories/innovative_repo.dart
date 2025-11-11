// // lib/data/datasources/innovative_strategies_api.dart
// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import '../../generated/models/responses/contexual_challenge/innovation_model.dart';
// import '../../generated/network.dart';
//
// class InnovativeStrategiesApi {
//   late final Dio _dio;
//
//   InnovativeStrategiesApi() {
//     final dioClient = Get.find<DioClient>();
//     _dio = dioClient.dio;
//   }
//
//   Future<List<InnovativeStrategy>> getInnovativeStrategies(int strategyId) async {
//     try {
//       print('🔍 API calling: /keywordbase-innovative/strategy/$strategyId');
//
//       final response = await _dio.get(
//         '/keywordbase-innovative/strategy/$strategyId',
//       );
//
//       if (response.statusCode == 200) {
//         final data = response.data;
//         print('🔍 API raw response type: ${data.runtimeType}');
//         print('🔍 API raw response: $data');
//
//         return _parseResponse(data);
//       } else {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           type: DioExceptionType.badResponse,
//           message: 'Failed to load innovative strategies: ${response.statusCode}',
//         );
//       }
//     } on DioException catch (e) {
//       print('❌ API DioException: ${e.message}');
//       throw Exception('Network error: ${e.message}');
//     } catch (e) {
//       print('❌ API general error: $e');
//       throw Exception('Failed to load innovative strategies: $e');
//     }
//   }
//
//   List<InnovativeStrategy> _parseResponse(dynamic data) {
//     List<InnovativeStrategy> strategies = [];
//
//     if (data is List) {
//       // Direct list of strategy objects
//       for (var item in data) {
//         if (item is Map<String, dynamic>) {
//           strategies.add(_parseStrategy(item));
//         }
//       }
//     } else if (data is Map<String, dynamic>) {
//       // Wrapper response with 'data' field
//       if (data.containsKey('data')) {
//         final responseData = data['data'];
//         if (responseData is List) {
//           strategies = responseData
//               .map((item) => _parseStrategy(item as Map<String, dynamic>))
//               .toList();
//         } else if (responseData is Map<String, dynamic>) {
//           strategies = [_parseStrategy(responseData)];
//         }
//       } else {
//         // Direct strategy object
//         strategies = [_parseStrategy(data)];
//       }
//     }
//
//     print('✅ API parsed ${strategies.length} strategies');
//     return strategies;
//   }
//
//   InnovativeStrategy _parseStrategy(Map<String, dynamic> json) {
//     print('🔍 Parsing strategy: ${json['id']}');
//
//     final strategy = InnovativeStrategy(
//       id: (json['id'] as num?)?.toInt() ?? 0,
//       strategyId: (json['strategyId'] as num?)?.toInt() ?? 0,
//       keyResult: json['keyResult'] as String? ?? '',
//       firstInnovative: _parseInnovativeItem(json['firstInnovative']),
//       secondInnovative: _parseInnovativeItem(json['secondInnovative']),
//       thirdInnovative: _parseInnovativeItem(json['thirdInnovative']),
//       createdAt: json['createdAt'] != null
//           ? DateTime.tryParse(json['createdAt'].toString())
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.tryParse(json['updatedAt'].toString())
//           : null,
//     );
//
//     print('✅ Parsed strategy keyResult: "${strategy.keyResult}"');
//     return strategy;
//   }
//
//   InnovativeItem? _parseInnovativeItem(dynamic itemData) {
//     if (itemData == null || itemData is! Map<String, dynamic>) {
//       return null;
//     }
//
//     try {
//       return InnovativeItem(
//         title: itemData['title'] as String? ?? '',
//         description: itemData['description'] as String? ?? '',
//       );
//     } catch (e) {
//       print('❌ Error parsing InnovativeItem: $e');
//       return null;
//     }
//   }
// }
// lib/data/datasources/innovative_strategies_api.dart
// lib/data/datasources/innovative_strategies_api.dart
// lib/data/datasources/innovative_strategies_api.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../generated/network.dart';

class InnovativeStrategiesApi {
  final DioClient _dioClient = Get.find<DioClient>();

  // ✅ CRITICAL: Return RAW DATA, not parsed models
  Future<List<dynamic>> getInnovativeStrategies(int strategyId) async {
    try {
      print('🔍 API calling: /keywordbase-innovative/strategy/$strategyId');

      final response = await _dioClient.dio.get(
        '/keywordbase-innovative/strategy/$strategyId',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('🔍 API raw response type: ${data.runtimeType}');
        print('🔍 API raw response: $data');

        // ✅ RETURN RAW DATA - NO MODEL PARSING HERE
        if (data is List) {
          print('✅ API returning raw List<dynamic> with ${data.length} items');
          return data; // This is List<Map<String, dynamic>>
        } else if (data is Map<String, dynamic>) {
          print('✅ API returning raw single Map wrapped in list');
          return [data];
        } else {
          throw Exception('Unexpected response format: ${data.runtimeType}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to load strategies');
      }
    } on DioException catch (e) {
      print('❌ API DioException: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('❌ API error: $e');
      throw Exception('Failed to load strategies: $e');
    }
  }
}