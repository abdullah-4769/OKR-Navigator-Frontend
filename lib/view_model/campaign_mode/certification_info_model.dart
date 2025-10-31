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
      'title': 'Leadership\nExcellence',
      'description': 'Long-term objective setting and planning',
      'icon': Icons.military_tech,
    },
    {
      'title': 'Stakeholder\nManagement',
      'description': 'Effective communication and relationship',
      'icon': Icons.groups,
    },
  ];

  Future<void> fetchCertificationInfo() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📍 Fetching certification information...');

      final result = await _repository.getCertificationInfo();
      _certificationInfo.value = result;

      print('✅ Certification info fetched successfully!');
      print('📊 Earned: ${result.progress.earned}, In Progress: ${result.progress.inProgress}, Total: ${result.progress.total}');
      print('🏆 Certifications: ${result.certifications.length}');

    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error in fetchCertificationInfo: $e');

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