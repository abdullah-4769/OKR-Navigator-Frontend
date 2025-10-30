import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../core/api_constants.dart';
import '../../generated/models/responses/contexual_challenge/innovation_model.dart';
import '../repositories/storage_repository.dart';

class InnovativeStrategiesApi {
  final Dio dio;

  InnovativeStrategiesApi(this.dio);

  Future<InnovativeStrategiesResponse> getInnovativeStrategies(int strategyId) async {
    try {
      // ✅ Get token from storage
      final storageRepository = Get.find<StorageRepository>();
      final token = await storageRepository.getAccessToken();

      // ✅ Use ApiConstants helper method instead of hardcoding URL
      final url = '${ApiConstants.baseUrl}${ApiConstants.keywordBaseInnovative}$strategyId';

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return InnovativeStrategiesResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load innovative strategies: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load innovative strategies: $e');
    }
  }
}
