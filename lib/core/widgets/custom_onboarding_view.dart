import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:octalian_task1/core/constants/colors.dart';
import 'package:octalian_task1/core/widgets/custom_button.dart';
import 'package:octalian_task1/core/widgets/custom_text.dart';
import 'package:octalian_task1/core/widgets/custom_text_button.dart';

class CustomOnboardingView extends StatelessWidget {
  const CustomOnboardingView({
    super.key,
    required this.text,
    required this.description,
    required this.image,
    required this.isLast,
    required this.pageController,
    required this.numPages,
    required this.onGetStarted,
  });

  final String text;
  final String description;
  final String image;
  final bool isLast;
  final PageController pageController;
  final int numPages;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: text,
                textColor: AppColors.primary,
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: description,
                textColor: AppColors.grey,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Quicksand',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 40.h),
          Image.asset(
            image,
            fit: BoxFit.contain,
            width: 300.w,
            height: 250.h,
          ),
          SizedBox(height: 100.h),
          isLast
              ? CustomButton(
            isLast: true,
            onPressed: onGetStarted,
            width: double.infinity,
            height: 40.h,
            borderRadius: BorderRadius.circular(15.0.r),
            gradientColors: [
              AppColors.primary,
              AppColors.secondary.withOpacity(0.85),
            ],
            child: CustomText(
                text: 'Get Started',
                textColor: AppColors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextButton(
                onPressed: () {
                  pageController.animateToPage(
                    numPages - 1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                text: 'Skip',
                textColor: AppColors.primary,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              CustomButton(
                onPressed: () {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                width: 140.w,
                height: 40.h,
                borderRadius: BorderRadius.circular(15.0.r),
                gradientColors: [
                  AppColors.primary,
                  AppColors.secondary.withOpacity(0.85),
                ],
                child: CustomText(
                    text: 'Next',
                    textColor: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
