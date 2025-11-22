import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task3/core/constants/colors.dart';
import 'package:task3/core/widgets/custom_text.dart';
import 'package:task3/data/models/task_model.dart';

class CustomTaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const CustomTaskItem({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: task.isCompleted
              ? AppColors.secondaryColor
              : (isDarkMode ? AppColors.darkContainerColor : AppColors.white),
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 30.h,
              width: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted ? AppColors.primaryColor : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted ? AppColors.primaryColor : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: task.isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 18.sp)
                  : null,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: task.title,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    textColor: task.isCompleted || isDarkMode ? Colors.white : Colors.black,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  SizedBox(height: 5.h),
                  CustomText(
                    text: task.note,
                    fontSize: 13.sp,
                    textColor: task.isCompleted ? Colors.white70 : Colors.grey,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            text: task.time,
                            fontSize: 12.sp,
                            textColor: task.isCompleted || isDarkMode ? Colors.white70 : Colors.grey[700],
                          ),
                          CustomText(
                            text: task.date,
                            fontSize: 12.sp,
                            textColor: task.isCompleted || isDarkMode ? Colors.white70 : Colors.grey[700],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}