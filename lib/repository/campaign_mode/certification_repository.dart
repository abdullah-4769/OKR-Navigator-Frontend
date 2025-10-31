import 'package:get/get.dart';

import '../../generated/models/responses/campaign/certification_info_mode.dart';
import '../../services/campaign/certificate_evaluation_service.dart';
import '../../services/campaign/certification_api_service.dart';

class CertificationInfoRepository {
  final CertificationInfoApiService _apiService = Get.find<CertificationInfoApiService>();

  Future<CertificationInfoResponse> getCertificationInfo() async {
    try {
      return await _apiService.getCertificationInfo();
    } catch (e) {
      print('❌ Repository error: $e');
      rethrow;
    }
  }
}