import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:octalian_task1/core/constants/colors.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({super.key, required this.imageName});

  final String imageName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50.w,
        width: 50.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary,width: 1.5.w),
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0.r),
          child: Image.asset(imageName),
        )
      ),
    );
  }
}
