import 'package:flutter/material.dart';
import 'custom_text.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.decoration,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(50, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerRight,
      ),
      child: CustomText(
        text: text,
        textColor: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
    );
  }
}
