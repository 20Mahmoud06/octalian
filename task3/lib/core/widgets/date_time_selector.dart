import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task3/core/widgets/custom_text.dart';

class DateTimeSelector extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const DateTimeSelector({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(15.r),
          color: isDarkMode ? Colors.grey[900] : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: label,
              fontSize: 16.sp,
              textColor: isDarkMode ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            CustomText(
              text: value,
              fontSize: 16.sp,
              textColor: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}