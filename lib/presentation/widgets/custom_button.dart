import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import 'package:flutter/services.dart';
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Widget? leading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.leading,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = AppDimensions.d30,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Responsive calculations
    final responsiveWidth = _getResponsiveWidth(screenWidth);
    final responsiveHeight = _getResponsiveHeight(screenHeight, screenWidth);
    final responsiveTextSize = _getResponsiveTextSize(screenWidth);
    final responsiveIconSize = _getResponsiveIconSize(screenWidth);
    final responsiveBorderRadius = _getResponsiveBorderRadius(screenWidth);
    final responsivePadding = _getResponsivePadding(screenWidth);

    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapCancel(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.width ?? responsiveWidth,
            height: widget.height ?? responsiveHeight,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : () => _handlePress(),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.backgroundColor ?? AppColors.primaryRed,
                disabledBackgroundColor: (widget.backgroundColor ?? AppColors.primaryRed)
                    .withOpacity(0.5),
                elevation: _isPressed ? 2 : 4,
                shadowColor: (widget.backgroundColor ?? AppColors.primaryRed)
                    .withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius != AppDimensions.d30
                        ? widget.borderRadius.r
                        : responsiveBorderRadius,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: responsivePadding,
                  vertical: responsivePadding * 0.6,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              child: widget.isLoading
                  ? _buildLoadingWidget(responsiveIconSize)
                  : _buildButtonContent(
                context,
                responsiveTextSize,
                responsiveIconSize,
                screenWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build loading widget with responsive sizing
  Widget _buildLoadingWidget(double iconSize) {
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: CircularProgressIndicator(
        color: widget.textColor ?? AppColors.white,
        strokeWidth: iconSize * 0.15,
      ),
    );
  }

  /// Build button content with responsive elements
  Widget _buildButtonContent(
      BuildContext context,
      double textSize,
      double iconSize,
      double screenWidth,
      ) {
    final responsiveSpacing = _getResponsiveSpacing(screenWidth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            color: widget.textColor ?? AppColors.white,
            size: iconSize,
          ),
          SizedBox(width: responsiveSpacing),
        ],
        if (widget.leading != null) ...[
          SizedBox(
            height: iconSize,
            child: widget.leading!,
          ),
          SizedBox(width: responsiveSpacing),
        ],
        Flexible(
          child: Text(
            widget.text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: widget.textColor ?? AppColors.white,
              fontSize: textSize,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// Handle button press with haptic feedback
  void _handlePress() {
    // Add haptic feedback for better UX
    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  /// Tap down animation
  void _onTapDown() {
    if (!widget.isLoading) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  /// Tap up animation
  void _onTapUp() {
    if (!widget.isLoading) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  /// Tap cancel animation
  void _onTapCancel() {
    if (!widget.isLoading) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  // 🔹 RESPONSIVE HELPER METHODS

  /// Get responsive button width
  double _getResponsiveWidth(double screenWidth) {
    if (screenWidth > 900) return 350.0; // Desktop
    if (screenWidth > 600) return 320.0; // Tablet
    if (screenWidth > 400) return 310.0; // Large mobile
    return screenWidth * 0.85; // Small mobile (adaptive)
  }

  /// Get responsive button height
  double _getResponsiveHeight(double screenHeight, double screenWidth) {
    // Consider both height and width for balanced proportions
    final baseHeight = screenHeight * 0.055; // Base on screen height

    if (screenWidth > 900) return baseHeight.clamp(50.0, 60.0);
    if (screenWidth > 600) return baseHeight.clamp(48.0, 55.0);
    if (screenWidth > 400) return baseHeight.clamp(45.0, 50.0);
    return baseHeight.clamp(42.0, 48.0);
  }

  /// Get responsive text size
  double _getResponsiveTextSize(double screenWidth) {
    if (screenWidth > 900) return 18.0;
    if (screenWidth > 600) return 17.0;
    if (screenWidth > 400) return 16.0;
    return 15.0;
  }

  /// Get responsive icon size
  double _getResponsiveIconSize(double screenWidth) {
    if (screenWidth > 900) return 24.0;
    if (screenWidth > 600) return 22.0;
    if (screenWidth > 400) return 20.0;
    return 18.0;
  }

  /// Get responsive border radius
  double _getResponsiveBorderRadius(double screenWidth) {
    final baseRadius = AppDimensions.d30;
    if (screenWidth > 600) return (baseRadius * 1.1).r;
    return baseRadius.r;
  }

  /// Get responsive padding
  double _getResponsivePadding(double screenWidth) {
    if (screenWidth > 900) return 24.0;
    if (screenWidth > 600) return 20.0;
    if (screenWidth > 400) return 16.0;
    return 12.0;
  }

  /// Get responsive spacing between elements
  double _getResponsiveSpacing(double screenWidth) {
    if (screenWidth > 600) return AppDimensions.d10.w;
    return AppDimensions.d8.w;
  }
}

