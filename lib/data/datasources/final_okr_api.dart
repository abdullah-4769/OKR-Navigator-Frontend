// lib/data/datasources/final_okr_evaluation_api.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:game_app/data/network/app_url.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../generated/models/responses/final_okr/final_okr.dart';
import '../repositories/storage_repository.dart';

class FinalOkrEvaluationApi {
  final Dio dio;

  FinalOkrEvaluationApi(this.dio);

  Future<FinalOkrEvaluationResponse> submitFinalOkrEvaluation(
      FinalOkrEvaluationRequest request) async {
    try {
      // Get token from storage
      final storageRepository = Get.find<StorageRepository>();
      final token = await storageRepository.getAccessToken();

      final response = await dio.post(
        '${AppUrls.finalOker}',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FinalOkrEvaluationResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to submit OKR evaluation: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to submit OKR evaluation: $e');
    }
  }
}