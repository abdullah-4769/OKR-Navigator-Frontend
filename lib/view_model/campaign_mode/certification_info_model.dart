import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/models/responses/campaign/certification_info_mode.dart';
import '../../repository/campaign_mode/certification_repository.dart';

class CertificationInfoViewModel extends GetxController {
  final CertificationInfoRepository _repository = Get.find<CertificationInfoRepository>();

  final Rx<CertificationInfoResponse?> _certificationInfo = Rx<CertificationInfoResponse?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  CertificationInfoResponse? get certificationInfo => _certificationInfo.value;

  // Available certifications (static data as per your design)
  final List<Map<String, dynamic>> availableCertifications = [
    {
      'title': 'leadership_excellence'.tr,
      'description': 'leadership_excellence_desc'.tr,
      'icon': Icons.military_tech,
    },
    {
      'title': 'stakeholder_management'.tr,
      'description': 'stakeholder_management_desc'.tr,
      'icon': Icons.groups,
    },
  ];

  Future<void> fetchCertificationInfo() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📍 ${'fetching_certifications'.tr}');

      final result = await _repository.getCertificationInfo();
      _certificationInfo.value = result;

      print('✅ ${'certification_fetched'.tr}');
      print('📊 ${'earned'.tr}: ${result.progress.earned}, ${'in_progress'.tr}: ${result.progress.inProgress}, ${'total'.tr}: ${result.progress.total}');
      print('🏆 ${result.certifications.length} certifications');

    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ ${'error_fetching_certifications'.tr}: $e');

      // Set default data on error
      _certificationInfo.value = CertificationInfoResponse(
        progress: ProgressInfo(earned: 0, total: 12, inProgress: 0),
        certifications: [],
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearData() {
    _certificationInfo.value = null;
    errorMessage.value = '';
  }

  bool get hasData => _certificationInfo.value != null;
}
