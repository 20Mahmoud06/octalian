import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:octalian_task1/core/constants/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomPageIndicator extends StatelessWidget {
   CustomPageIndicator({
    super.key,
    required this.controller,
    required this.numPages,
  });

  final PageController controller;
  final int numPages;
  final Color dotColor = AppColors.grey;
  final Color activeDotColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 100.0.h),
      child: SmoothPageIndicator(
        controller: controller,
        count: numPages,
        effect: WormEffect(
          dotColor: dotColor,
          activeDotColor: activeDotColor,
          dotHeight: 10.0,
          dotWidth: 10.0,
          type: WormType.thin,
        ),
      ),
    );
  }
}
