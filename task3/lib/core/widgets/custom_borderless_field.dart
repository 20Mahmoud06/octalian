import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBorderlessField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double fontSize;
  final int maxLines;
  final IconData? icon;
  final Color hintColor;
  final Color textColor;

  const CustomBorderlessField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.fontSize,
    this.maxLines = 1,
    this.icon,
    this.hintColor = Colors.grey,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Padding(
            padding: EdgeInsets.only(top: 12.h, right: 10.w),
            child: Icon(icon, color: Colors.grey, size: 24.sp),
          ),
        ],
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: fontSize,
                color: hintColor,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            ),
          ),
        ),
      ],
    );
  }
}