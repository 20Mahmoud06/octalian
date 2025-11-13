import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:octalian_task1/core/constants/colors.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    this.onChanged,
    required this.text,
    this.textInputAction,
    this.isPassword = false,
    this.isEmail = false,
    this.keyboardType,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String? Function(String?) validator;
  final void Function(String)? onChanged;
  final String text;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final bool isEmail;
  final TextInputType? keyboardType;
  final bool enabled;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = Colors.grey.shade700;
    final enabledBorderColor = AppColors.primary.withOpacity(0.5);
    final focusedBorderColor = AppColors.primary;
    final errorColor = theme.colorScheme.error;

    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0.r),
      borderSide: BorderSide(color: enabledBorderColor, width: 1.5.w),
    );

    final focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0.r),
      borderSide: BorderSide(color: focusedBorderColor, width: 2.0.w),
    );

    return TextFormField(
      enabled: widget.enabled,
      keyboardType: widget.keyboardType ?? (widget.isEmail
          ? TextInputType.emailAddress
          : TextInputType.text),
      textAlign: TextAlign.start,
      onChanged: widget.onChanged,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      obscureText: _obscureText,
      decoration: InputDecoration(
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: focusedOutlineInputBorder,
        errorBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: errorColor, width: 1.5.w),
        ),
        focusedErrorBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: errorColor, width: 2.0.w),
        ),
        isDense: true,
        hintText: widget.text,
        hintStyle: TextStyle(color: hintColor,fontFamily: 'Quicksand', fontWeight: FontWeight.w500),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 15.0.w),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.primary,
              size: 25.sp
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : Icon(Icons.email_outlined, color: AppColors.primary,size: 25.sp),
        ),
      style: TextStyle(color: Colors.grey.shade900, fontSize: 18.sp),
      cursorColor: Colors.grey.shade900,
    );
  }
}
