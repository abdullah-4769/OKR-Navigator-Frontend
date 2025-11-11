// lib/data/datasources/campaign_scenario_api.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../generated/network.dart';
import '../../core/api_constants.dart';

import '../../generated/models/requests/campaign_mode/campaign_scenerio_request_model.dart';
import '../../generated/models/responses/campaign/campaign_scenerio_response_model.dart';
import '../repositories/storage_repository.dart';

class CampaignScenarioApi {
  final Dio dio;

  CampaignScenarioApi(this.dio);

  Future<CampaignScenarioResponse> generateScenarioStrategy(CampaignScenarioRequest request) async {
    try {
      // Get token from storage
      final storageRepository = Get.find<StorageRepository>();
      final token = await storageRepository.getAccessToken();

      final response = await dio.post(
        ApiConstants.getUrl(ApiConstants.campaignCertificationScenario),
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CampaignScenarioResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to generate scenario: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to generate scenario strategy: $e');
    }
  }
}