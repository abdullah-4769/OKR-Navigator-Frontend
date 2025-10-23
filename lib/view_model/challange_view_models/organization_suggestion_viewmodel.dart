import 'package:get/get.dart';

import '../../generated/models/requests/challange_mode/organization_suggestion_model.dart';
import '../../repository/challange_repositories/organization_suggestion_repository.dart';
import '../../services/shared_preference.dart';


class CampaignSuggestionViewModel extends GetxController {
  final repository = CampaignSuggestionRepository();

  var isLoading = false.obs;
  var suggestion = Rxn<CampaignSuggestion>();
  var error = ''.obs;
  Future<void> loadSuggestion() async {
    try {
      isLoading.value = true;
      final role = SharedPrefs.getUserRole() ?? 'Product Manager';
      final language = 'English';

      // ✅ Use the correct method name that exists in repository
      final result = await repository.postRoleAndLanguage(role, language);

      // Convert the Map response to CampaignSuggestion model
      if (result != null) {
        suggestion.value = CampaignSuggestion.fromJson(result);
      }
    } catch (e) {
      error.value = e.toString();
      print("Error loading suggestion: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
