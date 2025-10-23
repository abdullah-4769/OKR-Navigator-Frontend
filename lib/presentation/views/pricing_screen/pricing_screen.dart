// presentation/views/pricing_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/game_mode_controller.dart';
import '../../../controllers/pricing_controller.dart';
import '../../../core/app_colors.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_svg.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';

class PricingScreen extends StatelessWidget {
  PricingScreen({super.key});

  final PricingController controller = Get.put(PricingController());
  final PageController pageController = PageController(viewportFraction: 0.85);
  final GameModeController gameModeController = Get.find();
  String trKey(Object? key) => key != null ? key.toString().tr : '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;
        final mediaQuery = MediaQuery.of(context);
        final screenHeight = mediaQuery.size.height;
        final screenWidth = mediaQuery.size.width;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                /// ---------- TOP BAR ----------
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.0,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.gameMode),
                        child: CustomCurvedArrow(
                          isLeft: true,
                          width: screenWidth * 0.15,
                          height: screenHeight * 0.17,
                            onTap: () {
                              Get.delete<PricingController>();
                              Get.toNamed(AppRoutes.gameMode);
                            }
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: screenHeight * 0.16,
                        width: screenWidth * 0.37,
                        child: CustomSvg(
                          assetPath: 'assets/images/okrnev.svg',
                          semanticsLabel: trKey('okr_logo'),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(width: screenWidth * 0.05),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.0),

                /// ---------- PRICING CARDS ----------
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: controller.pricingPlans.length,
                    onPageChanged: controller.onPageChanged,
                    itemBuilder: (context, index) {
                      final plan = controller.pricingPlans[index];
                      return Obx(() {
                        final bool isSelected =
                            controller.currentPageIndex.value == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(
                            horizontal: isSelected
                                ? screenWidth * 0.04
                                : screenWidth * 0.05,
                            vertical: isPortrait
                                ? screenHeight * 0.14
                                : screenHeight * 0.10,
                          ),
                          child: _buildPricingCard(
                            context,
                            plan,
                            isSelected,
                            screenHeight,
                            screenWidth,
                            theme,
                          ),
                        );
                      });
                    },
                  ),
                ),

                /// ---------- BOTTOM CONTROLS ----------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                            () => _buildArrowButton(
                          icon: Icons.arrow_back,
                          isDisabled: controller.currentPageIndex.value == 0,
                          onTap: () => controller.previousCard(pageController),
                          screenWidth: screenWidth,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.45,
                        child: CustomButton2(
                          text: trKey('select_continue'),
                          onPressed: controller.handleContinue, // ✅ new method
                        ),
                      ),



                      Obx(
                            () => _buildArrowButton(
                          icon: Icons.arrow_forward,
                          isDisabled: controller.currentPageIndex.value ==
                              controller.pricingPlans.length - 1,
                          onTap: () => controller.nextCard(pageController),
                          screenWidth: screenWidth,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPricingCard(
      BuildContext context,
      Map<String, dynamic> plan,
      bool isSelected,
      double screenHeight,
      double screenWidth,
      ThemeData theme,
      ) =>
      Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            elevation: isSelected ? 10 : 5,
            clipBehavior: Clip.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
              side: const BorderSide(color: AppColors.primaryRed),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: AppColors.softRed.withOpacity(0.4),
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan['price'].toString(),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: screenWidth * 0.055,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (plan['features'] as List).length,
                      separatorBuilder: (_, __) => Divider(
                        height: screenHeight * 0.02,
                        color: AppColors.grey.withOpacity(0.3),
                        thickness: 1,
                      ),
                      itemBuilder: (_, index) {
                        final feature = (plan['features'] as List)[index] as Map<String, dynamic>;
                        return Row(
                          children: [
                            Icon(
                              feature['included'] ? Icons.check_circle : Icons.cancel,
                              color: feature['included'] ? AppColors.sucessColor : AppColors.grey,
                              size: screenWidth * 0.04,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                trKey(feature['text']),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: screenWidth * 0.04,
                                  color: AppColors.textBlack,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ---------- Floating SVG (centered above card) ----------
          Positioned(
            top: -screenHeight * 0.13,
            left: (() {
              // center the svg regardless of intrinsic asset padding
              final svgWidth = screenWidth * 0.90;
              final left = (screenWidth - svgWidth) / 2;
              return left;
            }()),
            child: IgnorePointer(
              child: Obx(() {
                String svgPath = 'assets/images/solo.svg';
                try {
                  svgPath = controller.gameModeController.modeSvg;
                } catch (_) {
                  // fallback to solo if for any reason the game controller isn't available
                  svgPath = 'assets/images/solo.svg';
                }
                return CustomSvg(
                  assetPath: svgPath,
                  semanticsLabel: trKey(svgPath.split('/').last.split('.').first),
                  height: screenHeight * 0.15,
                  width: screenWidth * 0.22,
                );
              }),
            ),
          ),
        ],
      );

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDisabled,
    required double screenWidth,
  }) =>
      GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.03),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDisabled ? AppColors.grey.withOpacity(0.3) : AppColors.primaryRed,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: screenWidth * 0.06,
          ),
        ),
      );
}
