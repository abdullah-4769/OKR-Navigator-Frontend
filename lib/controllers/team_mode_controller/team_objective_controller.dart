import 'dart:developer';
import 'package:game_app/controllers/team_mode_controller/team_strategy_selection_controller.dart';
import 'package:get/get.dart';
import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/data/repositories/objective_repository.dart';
import 'package:game_app/generated/models/responses/objectives/objectives_response.dart';
import 'package:game_app/utils/snackbar_helper.dart';

class TeamObjectiveController extends GetxController {
  /// Observables
  final RxBool loading = false.obs;
  final RxList<Objective> objectives = <Objective>[].obs;
  final Rxn<Objective> selectedObjective = Rxn<Objective>();

  /// Repository instance
  final ObjectiveRepository repo = Get.find<ObjectiveRepository>();

  @override
  void onInit() {
    super.onInit();
  }


  /// Fetch team objectives based on team strategy
  Future<void> getTeamObjectives({
    required Map<String, dynamic> role,
    required Map<String, dynamic> industry,
  }) async {
    try {
      loading.value = true;
      final strategyController = Get.find<TeamStrategySelectionController>();
      final strategy = strategyController.teamStrategyResponse.value;

      if (strategy == null || strategy.strategyId == null) {
        throw Exception('No team strategy assigned');
      }

      final response = await repo.generateObjectives(
        strategyId: strategy.strategyId!,
        strategy: strategy.title ?? '',
        role: role['title']?.toString() ?? '',
        industry: industry['titleKey']?.toString() ?? '',
        language: Get.find<LanguageController>()
            .selectedLanguage
            .value
            .name
            .toLowerCase(),
      );

      objectives.assignAll(response);
    } catch (e, s) {
      log('Error fetching team objectives: $e', stackTrace: s);
      // It is now safe to show a Snackbar because this function is only called when the screen is active.
      SnackbarHelper.error('Failed to load team objectives. Using fallback data.');

      // Fallback to static data
      objectives.assignAll([
        Objective(
          title: 'expand_to_new_markets',
          description: 'expand_to_new_markets_desc',
        ),
        Objective(
          title: 'capture_market_share',
          description: 'capture_market_share_desc',
        ),
        Objective(
          title: 'launch_new_products',
          description: 'launch_new_products_desc',
        ),
      ]);
    } finally {
      loading.value = false;
    }
  }
  
  /// Return all objective titles (for generating comprehensive Key Results)
  List<String> getAllObjectiveTitles() {
    return objectives.map((obj) => obj.title ?? '').where((title) => title.isNotEmpty).toList();
  }

  /// Select / Deselect objective
  void selectObjective(Objective objective) {
    if (selectedObjective.value == objective) {
      selectedObjective.value = null;
    } else {
      selectedObjective.value = objective;
    }
  }

  /// Check if an objective is selected
  bool isSelected(Objective objective) => selectedObjective.value == objective;

  /// Enable button only when an objective is selected
  bool get isButtonEnabled => selectedObjective.value != null;

  /// Return selected title key
  String get selectedTitleKey => selectedObjective.value?.title ?? '';
}