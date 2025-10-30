import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    this.onPressed,
    this.borderRadius,
    this.isLast = false,
    required this.height,
    required this.width,
    required this.gradientColors,
    required this.child,
  });

  final VoidCallback? onPressed;
  final List<Color> gradientColors;
  final Widget child;
  final double height;
  final double width;
  final BorderRadiusGeometry? borderRadius;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(15.0.r),
      ),
      child: ElevatedButton.icon(
        icon: isLast ? Icon(Icons.arrow_forward, size: 24.0.w, color: AppColors.white,) : SizedBox.shrink(),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          iconAlignment: IconAlignment.end,
          iconColor: AppColors.white,
          foregroundColor: AppColors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          minimumSize: Size(width, height),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(30.0.r),
          ),
        ),
        label: child,
      ),
    );
  }
}
