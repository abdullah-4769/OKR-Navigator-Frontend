
import 'dart:ui';
import 'package:get/get.dart';
import '../../presentation/widgets/campaign_mode_widgets/organization_path_card.dart';
import '../../services/shared_preference.dart';

class MissionScreenController extends GetxController {
  /// Reactive values
  var orgName = "Organization A".obs;
  var orgSubtitle = "Startup Growth".obs;
  var stars = 2.obs;

  var industryTitle = "Foundation Startegic Alignment".obs;
  var industrySubtitle = "".obs; // Start with empty
  var bottomTitle = "Strategy, Objectives, and Key results".obs;
  var missionDescription = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadMissionDescription();
  }

  Future<void> loadMissionDescription() async {
    final savedDescription = await SharedPrefs.getMissionDescription();
    if (savedDescription != null && savedDescription.isNotEmpty) {
      missionDescription.value = savedDescription;
      industrySubtitle.value = savedDescription; // ✅ Set the subtitle here
      print("Loaded mission description: $savedDescription");
    } else {
      print("No mission description found in SharedPreferences");
      industrySubtitle.value = "Phase 1".tr; // Fallback
    }
  }

  /// Example path nodes
  final nodes = <OrgNode>[
    OrgNode(
      title: "Level 2",
      subtitle: "Organization B",
      imagePath: "assets/images/solo2.png",
      innerColors: [
        const Color(0xFFFFFFFF),
        const Color(0xFFEEEEEE),
        const Color(0xFFDDDDDD),
      ],
      borderGradient: [const Color(0xFFE53935), const Color(0xFFFFA726)],
    ),
    OrgNode(
      title: "You",
      subtitle: "Organization A",
      imagePath: "assets/images/campaign_image.png",
      innerColors: [
        const Color(0xFFFFFFFF),
        const Color(0xFFEEEEEE),
        const Color(0xFFDDDDDD),
      ],
      borderGradient: [const Color(0xFFE53935), const Color(0xFFFFA726)],
      isYou: true,
    ),
    OrgNode(
      title: "Level 3",
      subtitle: "Organization C",
      imagePath: "assets/images/campaign_image.png",
      innerColors: [
        const Color(0xFFFFFFFF),
        const Color(0xFFEEEEEE),
        const Color(0xFFDDDDDD),
      ],
      borderGradient: [const Color(0xFFE53935), const Color(0xFFFFA726)],
    ),
  ];

  /// Actions
  void onStartMission() {
    // TODO: Navigate to mission details
    print("Start Mission tapped");
  }

  void onNextSteps() {
    // TODO: Handle next steps action
    print("Next Steps tapped");
  }
}











// import 'dart:ui';
//
// import 'package:get/get.dart';
//
// import '../../presentation/widgets/campaign_mode_widgets/organization_path_card.dart';
//
//
// class MissionScreenController extends GetxController {
//   /// Reactive values
//   var orgName = "Organization A".obs;
//   var orgSubtitle = "Startup Growth".obs;
//   var stars = 2.obs;
//
//   var industryTitle = "Organization X".obs;
//   var industrySubtitle = "Phase 1".obs;
//   var bottomTitle = "3 Objectives".obs;
//
//   /// Example path nodes
//   final nodes = <OrgNode>[
//     OrgNode(
//       title: "Level 2",
//       subtitle: "Organization B",
//       imagePath: "assets/images/solo2.png",
//       innerColors: [
//         const Color(0xFFFFFFFF),
//         const Color(0xFFEEEEEE),
//         const Color(0xFFDDDDDD),
//       ],
//       borderGradient: [const Color(0xFFE53935), const Color(0xFFFFA726)],
//     ),
//     OrgNode(
//       title: "You",
//       subtitle: "Organization A",
//       imagePath: "assets/images/campaign_image.png",
//       innerColors: [
//         const Color(0xFFFFFFFF),
//         const Color(0xFFEEEEEE),
//         const Color(0xFFDDDDDD),
//       ],
//       borderGradient: [const Color(0xFFE53935), const Color(0xFFFFA726)],
//       isYou: true,
//     ),
//     OrgNode(
//       title: "Level 3",
//       subtitle: "Organization C",
//       imagePath: "assets/images/campaign_image.png",
//       innerColors: [
//         const Color(0xFFFFFFFF),
//         const Color(0xFFEEEEEE),
//         const Color(0xFFDDDDDD),
//       ],
//       borderGradient: [const Color(0xFFE53935), const Color(0xFFFFA726)],
//     ),
//   ];
//
//   /// Actions
//   void onStartMission() {
//     // TODO: Navigate to mission details
//     print("Start Mission tapped");
//   }
//
//   void onNextSteps() {
//     // TODO: Handle next steps action
//     print("Next Steps tapped");
//   }
// }
