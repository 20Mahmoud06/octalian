import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:octalian_task1/core/constants/colors.dart';
import 'package:octalian_task1/core/widgets/custom_button.dart';
import 'package:octalian_task1/core/widgets/custom_text.dart';
import 'package:octalian_task1/core/widgets/custom_text_button.dart';
import 'package:octalian_task1/core/widgets/custom_text_form_field.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/widgets/custom_icon_button.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 60.h,),
                        Center(
                          child: CustomText(
                            text: 'Sign up',
                            textColor: AppColors.primary,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40.h,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Email',
                              textColor: AppColors.black,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 5.h,),
                            CustomTextFormField(
                                keyboardType: TextInputType.emailAddress,
                                isEmail: true,
                                isPassword: false,
                                controller: emailController,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(v)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                text: 'Enter your email'
                            ),
                            SizedBox(height: 15.h,),
                            CustomText(
                              text: 'Password',
                              textColor: AppColors.black,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 5.h,),
                            CustomTextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                isEmail: false,
                                isPassword: true,
                                controller: passwordController,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please enter your password';
                                  } else if (v.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                                text: 'Enter your password'
                            ),
                            SizedBox(height: 15.h,),
                            CustomText(
                              text: 'Confirm Password',
                              textColor: AppColors.black,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 5.h,),
                            CustomTextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                isEmail: false,
                                isPassword: true,
                                controller: confirmPasswordController,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (v != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                text: 'Confirm your password'
                            ),
                            SizedBox(height: 30.h,),
                            Center(
                              child: CustomButton(
                                width: double.infinity,
                                height: 45.0.w,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: AppColors.primary,
                                        duration: Duration(seconds: 3),
                                        content: Text('Signing up...'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                        content: Text('Please fix the errors in red before submitting.'),
                                      ),
                                    );
                                  }
                                },
                                gradientColors: [
                                  AppColors.primary,
                                  AppColors.secondary.withOpacity(0.9),
                                ],
                                child: CustomText(
                                  text: 'Sign up',
                                  textColor: AppColors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              text: 'OR',
                              textColor: AppColors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomText(
                              text: 'Sign up with',
                              textColor: AppColors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconButton(
                                  imageName: 'assets/logos/facebook_logo.png',
                                ),
                                SizedBox(width: 15.w),
                                CustomIconButton(
                                  imageName: 'assets/logos/google_logo.png',
                                ),
                                SizedBox(width: 15.w),
                                CustomIconButton(
                                  imageName: 'assets/logos/apple_logo.png',
                                ),
                              ],
                            ),
                            SizedBox(height: 25.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: 'Already have an account?',
                                  textColor: AppColors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(width: 5.w),
                                CustomTextButton(
                                  text: 'Sign in',
                                  onPressed: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pushReplacementNamed(
                                          context, RouteNames.signin);
                                    }
                                  },
                                  textColor: AppColors.primary,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
