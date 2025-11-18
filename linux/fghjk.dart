// // ============================================
// // 1. FEEDBACK SCREEN - UPDATE (feedback_screen.dart)
// // ============================================
//
// class FeedbackScreen extends StatelessWidget {
//   final List<key_result_models.KeyResult> selectedKeyResults;
//
//   const FeedbackScreen({super.key, required this.selectedKeyResults});
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Get.put(FeedbackEvaluationViewModel());
//
//     // ✅ ADD: Check if bonus mode on screen load
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final gameMode = await SharedPrefs.getGameMode();
//
//       if (gameMode == 'bonus') {
//         // ✅ Call Bonus API instead of normal evaluation
//         await viewModel.evaluateBonusMode(selectedKeyResults);
//       } else {
//         // Normal evaluation for solo/campaign
//         viewModel.evaluateSelectedKeyResults(selectedKeyResults);
//       }
//     });
//
//     return Scaffold(
//       body: CustomBackground(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(vertical: 14.w),
//                 child: Column(
//                   children: [
//                     CustomHeader(
//                       title: 'okr'.tr,
//                       highlightedText: "feedback".tr,
//                       onBackTap: () => Get.back(),
//                     ),
//                     SizedBox(height: 20.h),
//                     Obx(() {
//                       if (viewModel.isLoadingData) {
//                         return Center(
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 100.h),
//                             child: CircularProgressIndicator(),
//                           ),
//                         );
//                       }
//
//                       if (!viewModel.hasData) {
//                         return Center(
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 100.h),
//                             child: Text('no_feedback_data_available'.tr),
//                           ),
//                         );
//                       }
//
//                       final feedback = viewModel.evaluationResult!;
//
//                       return Column(
//                         children: [
//                           // ✅ SHOW BONUS BADGE IF BONUS MODE
//                           FutureBuilder<String?>(
//                             future: SharedPrefs.getGameMode(),
//                             builder: (context, snapshot) {
//                               if (snapshot.data == 'bonus') {
//                                 return Padding(
//                                   padding: EdgeInsets.only(bottom: 16.h),
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 20.w,
//                                       vertical: 10.h,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           Color(0xFFFFD700),
//                                           Color(0xFFFFA500),
//                                         ],
//                                       ),
//                                       borderRadius: BorderRadius.circular(20.r),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Color(0xFFFFD700).withOpacity(0.4),
//                                           blurRadius: 10,
//                                           offset: Offset(0, 4),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Icon(Icons.stars, color: Colors.white, size: 24.sp),
//                                         SizedBox(width: 8.w),
//                                         Text(
//                                           'BONUS MODE',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16.sp,
//                                             fontFamily: 'GothamBold',
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }
//                               return SizedBox.shrink();
//                             },
//                           ),
//
//                           CustomScoreCard(
//                             title: "",
//                             score: feedback.overallScore,
//                             showBackground: false,
//                           ),
//                           SizedBox(height: 4.h),
//                           Padding(
//                             padding: EdgeInsets.all(8.w),
//                             child: _buildScoreBreakdown(feedback),
//                           ),
//                           SizedBox(height: 4.h),
//                           Padding(
//                             padding: EdgeInsets.all(12.w),
//                             child: _buildFeedbackCard(feedback),
//                           ),
//                           SizedBox(height: 24.h),
//
//                           // ✅ Navigation button
//                           Padding(
//                             padding: EdgeInsets.all(16.w),
//                             child: CustomButton2(
//                               text: 'continue'.tr,
//                               onPressed: () => _navigateBasedOnGameMode(),
//                             ),
//                           ),
//                           SizedBox(height: 20.h),
//                         ],
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               right: MediaQuery.of(context).size.width * -0.07,
//               top: MediaQuery.of(context).size.height * 0.50,
//               child: const CustomHomeNavBar(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ✅ UPDATED: Navigate based on game mode
//   void _navigateBasedOnGameMode() async {
//     try {
//       final savedMode = await SharedPrefs.getGameMode();
//
//       if (savedMode == 'campaign') {
//         _markLevelComplete();
//       }
//
//       // ✅ Navigate based on mode
//       switch (savedMode) {
//         case 'solo':
//         case 'challenge':
//           Get.toNamed(AppRoutes.suggestionInitiativeScreen);
//           break;
//
//         case 'campaign':
//           Get.offAllNamed(AppRoutes.campaignModeScreen);
//           break;
//
//         case 'bonus':
//         // ✅ BONUS MODE: Go back to home with success message
//           Get.snackbar(
//             'Bonus Complete! 🎉',
//             'You earned bonus points!',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Color(0xFFFFD700),
//             colorText: Colors.white,
//             icon: Icon(Icons.stars, color: Colors.white),
//             duration: Duration(seconds: 3),
//           );
//
//           // Clear bonus mode and return home
//           await SharedPrefs.clearGameMode();
//           Get.offAllNamed(AppRoutes.home);
//           break;
//
//         default:
//           Get.toNamed(AppRoutes.suggestionInitiativeScreen);
//           break;
//       }
//     } catch (e) {
//       print('❌ Error in navigation: $e');
//       Get.toNamed(AppRoutes.suggestionInitiativeScreen);
//     }
//   }
//
// // ... rest of the code remains same
// }
//
// // ============================================
// // 2. FEEDBACK EVALUATION VIEWMODEL - ADD BONUS API CALL
// // ============================================
//
// class FeedbackEvaluationViewModel extends GetxController {
//   final _isLoading = false.obs;
//   final Rx<FeedbackEvaluationModel?> _evaluationResult = Rx<FeedbackEvaluationModel?>(null);
//
//   bool get isLoadingData => _isLoading.value;
//   bool get hasData => _evaluationResult.value != null;
//   FeedbackEvaluationModel? get evaluationResult => _evaluationResult.value;
//
//   // ✅ NEW: Bonus Mode API Call
//   Future<void> evaluateBonusMode(List<KeyResult> selectedKeyResults) async {
//     try {
//       _isLoading.value = true;
//
//       // Get user ID (you may need to implement this based on your auth system)
//       final userId = await SharedPrefs.getUserId() ?? 'user123';
//
//       // Prepare request body
//       final requestBody = {
//         'userId': userId,
//         'selectedKeyResults': selectedKeyResults.map((kr) => {
//           'id': kr.id,
//           'title': kr.title,
//           'description': kr.description,
//         }).toList(),
//       };
//
//       print('📤 Sending Bonus Mode API Request: $requestBody');
//
//       // Call Bonus API
//       final response = await http.post(
//         Uri.parse('https://okr-navigator-backend.onrender.com/bonus-score'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );
//
//       print('📥 Bonus API Response Status: ${response.statusCode}');
//       print('📥 Bonus API Response Body: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//
//         // ✅ Parse the bonus response into your existing model
//         _evaluationResult.value = FeedbackEvaluationModel(
//           overallScore: data['overallScore'] ?? 0,
//           normalizedScore: data['normalizedScore'] ?? '0/30',
//           points: data['points'] ?? '0/3',
//           title: data['title'] ?? 'Good',
//           feedback: data['feedback'] ?? 'Well done!',
//           breakdown: FeedbackBreakdown(
//             strategyAlignment: FeedbackCategory(
//               title: data['strategyAlignmentTitle'] ?? 'Good',
//               score: data['strategyAlignmentScore'] ?? 0,
//               suggestion: data['strategyAlignmentSuggestion'] ?? '',
//             ),
//             objectiveAlignment: FeedbackCategory(
//               title: data['objectiveAlignmentTitle'] ?? 'Good',
//               score: data['objectiveAlignmentScore'] ?? 0,
//               suggestion: data['objectiveAlignmentSuggestion'] ?? '',
//             ),
//             keyResultQuality: FeedbackCategory(
//               title: data['keyResultQualityTitle'] ?? 'Good',
//               score: data['keyResultQualityScore'] ?? 0,
//               suggestion: data['keyResultQualitySuggestion'] ?? '',
//             ),
//           ),
//         );
//
//         // ✅ Save bonus score to SharedPreferences
//         await SharedPrefs.saveBonusScore(data['overallScore'] ?? 0);
//         await SharedPrefs.saveBonusPoints(data['points'] ?? '0/3');
//
//         print('✅ Bonus Mode Evaluation Successful!');
//         print('🎯 Score: ${data['overallScore']}');
//         print('⭐ Points: ${data['points']}');
//
//         Get.snackbar(
//           'Bonus Score Received! 🎉',
//           'You scored ${data['overallScore']}/100',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: AppColors.primaryGreen,
//           colorText: Colors.white,
//         );
//
//       } else {
//         throw Exception('Bonus API failed with status: ${response.statusCode}');
//       }
//
//     } catch (e) {
//       print('❌ Bonus Mode Evaluation Error: $e');
//
//       Get.snackbar(
//         'Error',
//         'Failed to get bonus score. Please try again.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.primaryRed,
//         colorText: Colors.white,
//       );
//
//       // ✅ Fallback: Use dummy data for testing
//       _evaluationResult.value = _getDummyBonusData();
//
//     } finally {
//       _isLoading.value = false;
//     }
//   }
//
//   // ✅ Dummy data for testing
//   FeedbackEvaluationModel _getDummyBonusData() {
//     return FeedbackEvaluationModel(
//       overallScore: 85,
//       normalizedScore: '25.5/30',
//       points: '3/3',
//       title: 'Good',
//       feedback: 'The OKRs are well-aligned with the strategy and are positioned to enhance customer engagement.',
//       breakdown: FeedbackBreakdown(
//         strategyAlignment: FeedbackCategory(
//           title: 'Good',
//           score: 25,
//           suggestion: 'Add elements directly tied to increasing lifetime value.',
//         ),
//         objectiveAlignment: FeedbackCategory(
//           title: 'Perfect',
//           score: 30,
//           suggestion: 'The objective is specific, measurable, and time-bound.',
//         ),
//         keyResultQuality: FeedbackCategory(
//           title: 'Good',
//           score: 30,
//           suggestion: 'Consider additional key results for different engagement aspects.',
//         ),
//       ),
//     );
//   }
//
// // ... existing evaluateSelectedKeyResults method remains same
// }
//
// // ============================================
// // 3. SHARED PREFERENCES - ADD BONUS HELPERS
// // ============================================
//
//
// // ============================================
// // 4. HOME SCREEN - UPDATE BONUS BUTTON (home_screen.dart)
// // ============================================
//
// // In your _mainCardsSectionContent() method, update the bonus button:
//
//
// // ============================================
// // 5. TESTING CHECKLIST
// // ============================================
//
// /*
// ✅ TESTING STEPS:
//
// 1. Home Screen:
//    - Click "Bonus Mode" button
//    - Check if dialog appears with "Start Bonus Mode"
//    - Verify bonus mode is saved
//
// 2. Role Selection:
//    - Select a role
//    - Continue to industry selection
//
// 3. Industry Selection:
//    - Select an industry
//    - Continue to strategy selection
//
// 4. Strategy Selection:
//    - Select a strategy
//    - Begin mission to objectives
//
// 5. Objective Selection:
//    - Select one objective
//    - Complete selection
//
// 6. Key Results Selection:
//    - Select 3 key results
//    - Complete selection
//
// 7. Feedback Screen:
//    - Should show "BONUS MODE" badge at top
//    - Should call bonus API automatically
//    - Check if response shows:
//      * Overall Score
//      * Normalized Score (X/30)
//      * Points (X/3)
//      * Feedback text
//      * Strategy, Objective, Key Result scores
//
// 8. After Feedback:
//    - Click "Continue"
//    - Should show success snackbar
//    - Should return to home screen
//    - Bonus mode should be cleared
//
// 9. Verify Data:
//    - Check SharedPreferences for bonus_score
//    - Check SharedPreferences for bonus_points
//    - Verify game mode is cleared after completion
//
// 10. API Testing:
//     - Check network logs for bonus API call
//     - Verify request body contains userId and selectedKeyResults
//     - Confirm response matches expected format
// */
// Widget _mainCardsSectionContent() => Row(
//   mainAxisAlignment: MainAxisAlignment.start,
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     // Robot arrow with bounce and blink animation
//     Center(
//       child: Padding(
//         padding: EdgeInsets.only(left: 12.w),
//         child: AnimatedBuilder(
//           animation: Listenable.merge([_robotBounceAnimation, _blinkAnimation]),
//           builder: (context, child) => Transform.translate(
//             offset: Offset(0, -10 * _robotBounceAnimation.value),
//             child: Opacity(
//               opacity: _blinkAnimation.value,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/robortarrow.png',
//                     height: 90.h,
//                     fit: BoxFit.contain,
//                   ),
//                   SizedBox(height: 8.h),
//                   InkWell(
//                     onTap: () async {
//                       // ✅ Clear previous session data
//                       await SharedPrefs.clearGameSessionData();
//
//                       // ✅ Set bonus mode
//                       await SharedPrefs.saveGameMode("bonus");
//                       print("✅ BONUS MODE ACTIVATED");
//
//                       // ✅ Show bonus mode dialog
//                       Get.dialog(
//                         Dialog(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20.r),
//                           ),
//                           child: Container(
//                             padding: EdgeInsets.all(24.w),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Color(0xFFFFD700),
//                                   Color(0xFFFFA500),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(20.r),
//                             ),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.stars,
//                                   size: 64.sp,
//                                   color: Colors.white,
//                                 ),
//                                 SizedBox(height: 16.h),
//                                 Text(
//                                   'Bonus Mode! 🎉',
//                                   style: TextStyle(
//                                     fontSize: 24.sp,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     fontFamily: 'GothamBold',
//                                   ),
//                                 ),
//                                 SizedBox(height: 12.h),
//                                 Text(
//                                   'Complete the OKR journey and earn bonus points!',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 14.sp,
//                                     color: Colors.white,
//                                     fontFamily: 'Gotham',
//                                   ),
//                                 ),
//                                 SizedBox(height: 24.h),
//                                 CustomButton2(
//                                   text: 'Start Bonus Mode',
//                                   onPressed: () {
//                                     Get.back(); // Close dialog
//                                     Get.toNamed(
//                                       AppRoutes.roleSelection,
//                                       arguments: {"fromBonus": true},
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         barrierDismissible: false,
//                       );
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12.w,
//                         vertical: 6.h,
//                       ),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//                         ),
//                         borderRadius: BorderRadius.circular(20.r),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0xFFFFD700).withOpacity(0.4),
//                             blurRadius: 8,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.stars,
//                             color: Colors.white,
//                             size: 16.sp,
//                           ),
//                           SizedBox(width: 4.w),
//                           Text(
//                             "Bonus Mode",
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               fontFamily: 'GothamBold',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//
//     // ... rest of the cards
//   ],
// );
