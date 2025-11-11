import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CustomShareButton extends StatefulWidget {
  final String text;
  final GlobalKey? repaintBoundaryKey;
  final Widget? leading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final String? shareText;
  final String? fileName;
  final VoidCallback? onPressed;
  final Function()? onError; // Callback for error handling

  const CustomShareButton({
    super.key,
    this.text = 'Share Result',
    this.repaintBoundaryKey,
    this.leading,
    this.icon = Icons.share,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = AppDimensions.d30,
    this.shareText,
    this.fileName,
    this.onError, this.onPressed,
  });

  @override
  State<CustomShareButton> createState() => _CustomShareButtonState();
}

class _CustomShareButtonState extends State<CustomShareButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  bool _isSharing = false;

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

  /// Improved capture and share method
  Future<void> _captureAndShare() async {
    if (_isSharing) return;

    setState(() => _isSharing = true);

    try {
      // Check if repaint boundary key is provided and valid
      if (widget.repaintBoundaryKey == null) {
        _showError('Repaint boundary key is required for sharing.');
        widget.onError?.call();
        return;
      }

      // Wait for the next frame to ensure widget is rendered
      await Future.delayed(const Duration(milliseconds: 100));

      final BuildContext? context = widget.repaintBoundaryKey!.currentContext;
      if (context == null) {
        _showError('Unable to access widget context. Please try again.');
        widget.onError?.call();
        return;
      }

      // Find the RenderRepaintBoundary
      final RenderObject? renderObject = context.findRenderObject();
      if (renderObject == null || renderObject is! RenderRepaintBoundary) {
        _showError('Widget not properly rendered. Please ensure RepaintBoundary is used.');
        widget.onError?.call();
        return;
      }

      final RenderRepaintBoundary boundary = renderObject;

      // Capture with higher pixel ratio for better quality
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // Convert to bytes
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        _showError('Failed to convert image to bytes.');
        widget.onError?.call();
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName = widget.fileName ??
          'certification_result_${DateTime.now().millisecondsSinceEpoch}.png';
      final File file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(pngBytes);

      // Share the file
      final XFile xFile = XFile(file.path);
      await Share.shareXFiles(
        [xFile],
        text: widget.shareText ?? 'Check out my certification results! 🎯',
        subject: 'OKR Certification Results',
      );

      // Clean up after sharing (optional)
      _cleanupFile(file);

      // Show success feedback
      if (mounted) {
        _showSuccess();
      }

    } catch (e) {
      _showError('Failed to share: ${e.toString()}');
      widget.onError?.call();
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  /// Clean up temporary file after sharing
  void _cleanupFile(File file) async {
    try {
      if (await file.exists()) {
        // You can choose to delete immediately or keep for a while
        // await file.delete();
      }
    } catch (e) {
      print('Error cleaning up file: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ready to share!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
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
              onPressed: _isSharing ? null : _captureAndShare,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.backgroundColor ?? AppColors.primaryRed,
                disabledBackgroundColor:
                (widget.backgroundColor ?? AppColors.primaryRed)
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
              ),
              child: _isSharing
                  ? _buildLoadingWidget(responsiveIconSize)
                  : _buildButtonContent(
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

  Widget _buildButtonContent(
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
            style: TextStyle(
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

  void _onTapDown() {
    if (!_isSharing) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _onTapUp() {
    if (!_isSharing) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (!_isSharing) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  // Responsive helper methods
  double _getResponsiveWidth(double screenWidth) {
    if (screenWidth > 900) return 350.0;
    if (screenWidth > 600) return 320.0;
    if (screenWidth > 400) return 310.0;
    return screenWidth * 0.85;
  }

  double _getResponsiveHeight(double screenHeight, double screenWidth) {
    final baseHeight = screenHeight * 0.055;
    if (screenWidth > 900) return baseHeight.clamp(50.0, 60.0);
    if (screenWidth > 600) return baseHeight.clamp(48.0, 55.0);
    if (screenWidth > 400) return baseHeight.clamp(45.0, 50.0);
    return baseHeight.clamp(42.0, 48.0);
  }

  double _getResponsiveTextSize(double screenWidth) {
    if (screenWidth > 900) return 18.0;
    if (screenWidth > 600) return 17.0;
    if (screenWidth > 400) return 16.0;
    return 15.0;
  }

  double _getResponsiveIconSize(double screenWidth) {
    if (screenWidth > 900) return 24.0;
    if (screenWidth > 600) return 22.0;
    if (screenWidth > 400) return 20.0;
    return 18.0;
  }

  double _getResponsiveBorderRadius(double screenWidth) {
    final baseRadius = AppDimensions.d30;
    if (screenWidth > 600) return (baseRadius * 1.1).r;
    return baseRadius.r;
  }

  double _getResponsivePadding(double screenWidth) {
    if (screenWidth > 900) return 24.0;
    if (screenWidth > 600) return 20.0;
    if (screenWidth > 400) return 16.0;
    return 12.0;
  }

  double _getResponsiveSpacing(double screenWidth) {
    if (screenWidth > 600) return AppDimensions.d10.w;
    return AppDimensions.d8.w;
  }
}













// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/rendering.dart';
// import 'dart:ui' as ui;
// import 'dart:typed_data';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:io';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
//
// class CustomShareButton extends StatefulWidget {
//   final String text;
//   final GlobalKey? repaintBoundaryKey; // Key for the widget to capture
//   final Widget? leading;
//   final IconData? icon;
//   final Color? backgroundColor;
//   final Color? textColor;
//   final double? width;
//   final double? height;
//   final double borderRadius;
//   final String? shareText; // Optional text to share with image
//   final String? fileName; // Optional custom filename
//
//   const CustomShareButton({
//     super.key,
//     this.text = 'Share Result',
//     this.repaintBoundaryKey,
//     this.leading,
//     this.icon = Icons.share,
//     this.backgroundColor,
//     this.textColor,
//     this.width,
//     this.height,
//     this.borderRadius = AppDimensions.d30,
//     this.shareText,
//     this.fileName,
//   });
//
//   @override
//   State<CustomShareButton> createState() => _CustomShareButtonState();
// }
//
// class _CustomShareButtonState extends State<CustomShareButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   bool _isPressed = false;
//   bool _isSharing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 150),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.95,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   /// Capture the widget as an image and share it
//   Future<void> _captureAndShare() async {
//     if (_isSharing) return;
//
//     setState(() => _isSharing = true);
//
//     try {
//       // Get the RepaintBoundary key
//       final key = widget.repaintBoundaryKey;
//
//       if (key == null || key.currentContext == null) {
//         _showError('Unable to capture screen. Please wrap your screen with RepaintBoundary.');
//         return;
//       }
//
//       // Find the RenderRepaintBoundary
//       RenderRepaintBoundary? boundary =
//       key.currentContext!.findRenderObject() as RenderRepaintBoundary?;
//
//       if (boundary == null) {
//         _showError('Unable to find boundary to capture.');
//         return;
//       }
//
//       // Capture the image with high quality
//       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//
//       // Convert to PNG bytes
//       ByteData? byteData = await image.toByteData(
//         format: ui.ImageByteFormat.png,
//       );
//
//       if (byteData == null) {
//         _showError('Failed to convert image to bytes.');
//         return;
//       }
//
//       Uint8List pngBytes = byteData.buffer.asUint8List();
//
//       // Save to temporary directory
//       final tempDir = await getTemporaryDirectory();
//       final fileName = widget.fileName ?? 'result_${DateTime.now().millisecondsSinceEpoch}';
//       final file = await File('${tempDir.path}/$fileName.png').create();
//       await file.writeAsBytes(pngBytes);
//
//       // Share the file
//       final xFile = XFile(file.path);
//       await Share.shareXFiles(
//         [xFile],
//         text: widget.shareText ?? 'Check out my result!',
//       );
//
//       // Show success feedback
//       if (mounted) {
//         _showSuccess();
//       }
//     } catch (e) {
//       _showError('Failed to share: ${e.toString()}');
//     } finally {
//       if (mounted) {
//         setState(() => _isSharing = false);
//       }
//     }
//   }
//
//   /// Show error message
//   void _showError(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
//
//   /// Show success message
//   void _showSuccess() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Ready to share!'),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 1),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenWidth = mediaQuery.size.width;
//     final screenHeight = mediaQuery.size.height;
//
//     // Responsive calculations
//     final responsiveWidth = _getResponsiveWidth(screenWidth);
//     final responsiveHeight = _getResponsiveHeight(screenHeight, screenWidth);
//     final responsiveTextSize = _getResponsiveTextSize(screenWidth);
//     final responsiveIconSize = _getResponsiveIconSize(screenWidth);
//     final responsiveBorderRadius = _getResponsiveBorderRadius(screenWidth);
//     final responsivePadding = _getResponsivePadding(screenWidth);
//
//     return GestureDetector(
//       onTapDown: (_) => _onTapDown(),
//       onTapUp: (_) => _onTapUp(),
//       onTapCancel: () => _onTapCancel(),
//       child: AnimatedBuilder(
//         animation: _scaleAnimation,
//         builder: (context, child) => Transform.scale(
//           scale: _scaleAnimation.value,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: widget.width ?? responsiveWidth,
//             height: widget.height ?? responsiveHeight,
//             child: ElevatedButton(
//               onPressed: _isSharing ? null : () => _handlePress(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: widget.backgroundColor ?? AppColors.primaryRed,
//                 disabledBackgroundColor:
//                 (widget.backgroundColor ?? AppColors.primaryRed)
//                     .withOpacity(0.5),
//                 elevation: _isPressed ? 2 : 4,
//                 shadowColor: (widget.backgroundColor ?? AppColors.primaryRed)
//                     .withOpacity(0.3),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(
//                     widget.borderRadius != AppDimensions.d30
//                         ? widget.borderRadius.r
//                         : responsiveBorderRadius,
//                   ),
//                 ),
//                 padding: EdgeInsets.symmetric(
//                   horizontal: responsivePadding,
//                   vertical: responsivePadding * 0.6,
//                 ),
//                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 visualDensity: VisualDensity.adaptivePlatformDensity,
//               ),
//               child: _isSharing
//                   ? _buildLoadingWidget(responsiveIconSize)
//                   : _buildButtonContent(
//                 context,
//                 responsiveTextSize,
//                 responsiveIconSize,
//                 screenWidth,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Build loading widget with responsive sizing
//   Widget _buildLoadingWidget(double iconSize) {
//     return SizedBox(
//       width: iconSize,
//       height: iconSize,
//       child: CircularProgressIndicator(
//         color: widget.textColor ?? AppColors.white,
//         strokeWidth: iconSize * 0.15,
//       ),
//     );
//   }
//
//   /// Build button content with responsive elements
//   Widget _buildButtonContent(
//       BuildContext context,
//       double textSize,
//       double iconSize,
//       double screenWidth,
//       ) {
//     final responsiveSpacing = _getResponsiveSpacing(screenWidth);
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (widget.icon != null) ...[
//           Icon(
//             widget.icon,
//             color: widget.textColor ?? AppColors.white,
//             size: iconSize,
//           ),
//           SizedBox(width: responsiveSpacing),
//         ],
//         if (widget.leading != null) ...[
//           SizedBox(
//             height: iconSize,
//             child: widget.leading!,
//           ),
//           SizedBox(width: responsiveSpacing),
//         ],
//         Flexible(
//           child: Text(
//             widget.text,
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               color: widget.textColor ?? AppColors.white,
//               fontSize: textSize,
//               fontWeight: FontWeight.w600,
//             ),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Handle button press with haptic feedback
//   void _handlePress() {
//     HapticFeedback.lightImpact();
//     _captureAndShare();
//   }
//
//   /// Tap down animation
//   void _onTapDown() {
//     if (!_isSharing) {
//       setState(() => _isPressed = true);
//       _animationController.forward();
//     }
//   }
//
//   /// Tap up animation
//   void _onTapUp() {
//     if (!_isSharing) {
//       setState(() => _isPressed = false);
//       _animationController.reverse();
//     }
//   }
//
//   /// Tap cancel animation
//   void _onTapCancel() {
//     if (!_isSharing) {
//       setState(() => _isPressed = false);
//       _animationController.reverse();
//     }
//   }
//
//   // 🔹 RESPONSIVE HELPER METHODS
//
//   double _getResponsiveWidth(double screenWidth) {
//     if (screenWidth > 900) return 350.0;
//     if (screenWidth > 600) return 320.0;
//     if (screenWidth > 400) return 310.0;
//     return screenWidth * 0.85;
//   }
//
//   double _getResponsiveHeight(double screenHeight, double screenWidth) {
//     final baseHeight = screenHeight * 0.055;
//     if (screenWidth > 900) return baseHeight.clamp(50.0, 60.0);
//     if (screenWidth > 600) return baseHeight.clamp(48.0, 55.0);
//     if (screenWidth > 400) return baseHeight.clamp(45.0, 50.0);
//     return baseHeight.clamp(42.0, 48.0);
//   }
//
//   double _getResponsiveTextSize(double screenWidth) {
//     if (screenWidth > 900) return 18.0;
//     if (screenWidth > 600) return 17.0;
//     if (screenWidth > 400) return 16.0;
//     return 15.0;
//   }
//
//   double _getResponsiveIconSize(double screenWidth) {
//     if (screenWidth > 900) return 24.0;
//     if (screenWidth > 600) return 22.0;
//     if (screenWidth > 400) return 20.0;
//     return 18.0;
//   }
//
//   double _getResponsiveBorderRadius(double screenWidth) {
//     final baseRadius = AppDimensions.d30;
//     if (screenWidth > 600) return (baseRadius * 1.1).r;
//     return baseRadius.r;
//   }
//
//   double _getResponsivePadding(double screenWidth) {
//     if (screenWidth > 900) return 24.0;
//     if (screenWidth > 600) return 20.0;
//     if (screenWidth > 400) return 16.0;
//     return 12.0;
//   }
//
//   double _getResponsiveSpacing(double screenWidth) {
//     if (screenWidth > 600) return AppDimensions.d10.w;
//     return AppDimensions.d8.w;
//   }
// }