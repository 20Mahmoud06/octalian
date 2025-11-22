import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task3/core/constants/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({super.key, required this.controller, required this.onTap,});

  final TextEditingController controller;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        filled: true,
        fillColor: isDarkMode ? AppColors.darkContainerColor : Colors.transparent,
      ),
    );
  }
}