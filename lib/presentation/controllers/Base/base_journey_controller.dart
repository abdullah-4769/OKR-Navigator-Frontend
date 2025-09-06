// import 'package:get/get.dart';
//
// abstract class BaseJourneyController extends GetxController {
//   var showDetails = false.obs;
//   var progress = 0.0.obs;
//   var completedSteps = <bool>[].obs;
//
//   List<String> get steps;
//
//   int get totalSteps => steps.length;
//
//   @override
//   void onInit() {
//     super.onInit();
//     completedSteps.value = List.generate(totalSteps, (_) => false);
//   }
//
//   void toggleJourneyDetails() {
//     showDetails.value = !showDetails.value;
//   }
//
//   void updateProgress() {
//     final completed = completedSteps.where((done) => done).length;
//     final stepPercentage = 100 / totalSteps;
//     progress.value = (completed * stepPercentage).clamp(0, 100);
//   }
//
//   void completeStep(int stepIndex) {
//     if (stepIndex < totalSteps) {
//       completedSteps[stepIndex] = true;
//       updateProgress();
//     }
//   }
//
//   void resetProgress() {
//     progress.value = 0.0;
//     completedSteps.value = List.generate(totalSteps, (_) => false);
//     showDetails.value = false;
//   }
// }
