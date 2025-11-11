import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controllers/widgets_controllers/top_performer_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CustomTopPerformerWidget extends StatelessWidget {
  CustomTopPerformerWidget({super.key});

  final TopPerformerController controller = Get.put(TopPerformerController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

    return Padding(
      padding: EdgeInsets.all(AppDimensions.d16.w),
      child: Column(
        children: [
          /// 🔥 Timeframe Tabs
          Obx(
                () => Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.d16.r),
                border: Border.all(color: AppColors.grey.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  {"key": "today", "label": "today".tr},
                  {"key": "this_week", "label": "this_week".tr},
                  {"key": "this_month", "label": "this_month".tr},
                ].map((tab) {
                  final isSelected =
                      controller.selectedTimeframe.value == tab["key"];
                  return GestureDetector(
                    onTap: () => controller.changeTimeframe(tab["key"]!),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.d15.w,
                        vertical: AppDimensions.d10.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                        isSelected ? AppColors.primaryRed : Colors.white,
                        borderRadius:
                        BorderRadius.circular(AppDimensions.d12.r),
                      ),
                      child: Text(
                        tab["label"]!,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.primaryRed,
                          fontWeight: FontWeight.w600,
                          fontSize: AppDimensions.d14.sp,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.d20.h),

          /// 🔥 Podium Section
          Obx(() {
            if (controller.performers.isEmpty) {
              return Center(child: Text("No data".tr));
            }

            final performers = controller.performers;

            return LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final blockWidth = (maxWidth / 3) - 16.w;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// 🥈 2nd
                    Flexible(
                      child: _buildPodiumTile(
                        name: performers[1]["name"],
                        score: performers[1]["score"],
                        level: performers[1]["level"],
                        rank: 2,
                        height: isPortrait
                            ? size.height * 0.20
                            : size.height * 0.25,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB0BEC5), Color(0xFF90A4AE)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: blockWidth,
                      ),
                    ),

                    /// 🥇 1st
                    Flexible(
                      child: _buildPodiumTile(
                        name: performers[0]["name"],
                        score: performers[0]["score"],
                        level: performers[0]["level"],
                        rank: 1,
                        height: isPortrait
                            ? size.height * 0.26
                            : size.height * 0.32,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFF176), Color(0xFFFBC02D)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: blockWidth,
                      ),
                    ),

                    /// 🥉 3rd
                    Flexible(
                      child: _buildPodiumTile(
                        name: performers[2]["name"],
                        score: performers[2]["score"],
                        level: performers[2]["level"],
                        rank: 3,
                        height: isPortrait
                            ? size.height * 0.18
                            : size.height * 0.22,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFA726), Color(0xFFEF6C00)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: blockWidth,
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }

  /// 🔥 Podium Tile Builder
  Widget _buildPodiumTile({
    required String name,
    required int score,
    required int level,
    required int rank,
    required double height,
    required Gradient gradient,
    required double width,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        /// Avatar + Rank
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryRed, width: 2.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                "assets/images/solo.svg",
                height: AppDimensions.d55.w, // Bigger Avatar
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: rank == 1 ? AppColors.primaryRed : Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "$rank",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.d12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.d8.h),

        /// Podium Block
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppDimensions.d12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(2, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Center(
                child: Text(
                  "⭐\n$score",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.d18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.d6.h),
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimensions.d14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppDimensions.d4.h),

            ],
          ),
        ),
      ],
    );
  }
}
