import 'package:flutter/material.dart';
import 'package:game_app/core/app_colors.dart';
import 'package:game_app/core/app_constants.dart';
import 'package:get/get.dart';

class CustomBubbleButton extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onTap;

  const CustomBubbleButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  State<CustomBubbleButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomBubbleButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: () => setState(() => _scale = 1.0),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 120),
          child: Container(

            width: widget.width > screenWidth ? screenWidth * 0.9 : widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              color: AppColors.lightSkyBlue,
              borderRadius: BorderRadius.circular(30), 

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: FittedBox(
              child: Text(
                widget.text.tr,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
