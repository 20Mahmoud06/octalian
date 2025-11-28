import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:task3/core/constants/colors.dart';
import 'package:task3/core/widgets/custom_button.dart';
import 'package:task3/core/widgets/custom_text.dart';
import 'package:task3/core/widgets/custom_borderless_field.dart';
import 'package:task3/core/widgets/date_time_selector.dart';
import 'package:task3/data/models/task_model.dart';
import 'package:task3/cubits/task_cubit.dart';
import 'package:task3/cubits/theme_cubit.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late FToast fToast;

  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _noteController = TextEditingController(
      text: (widget.task?.note == "No Description")
          ? ''
          : (widget.task?.note ?? ''),
    );

    if (widget.task != null) {
      try {
        _selectedDate = DateFormat('EEE, MMM d, yyyy').parse(widget.task!.date);
        _selectedTime = DateFormat('hh:mm a').parse(widget.task!.time);
      } catch (e) {
        _selectedDate = DateTime.now();
        _selectedTime = DateTime.now();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showToast(String text, {bool isError = false}) {
    fToast.init(context);
    Widget toast = Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 12.0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0.r),
        color: isError ? Colors.redAccent : Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check,
            color: Colors.white,
          ),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250.h,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: 190.h,
              child: CupertinoDatePicker(
                initialDateTime: _selectedDate,
                mode: CupertinoDatePickerMode.date,
                minimumDate: DateTime.now().subtract(const Duration(days: 365)),
                maximumDate: DateTime(2030),
                onDateTimeChanged: (val) {
                  setState(() {
                    _selectedDate = val;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250.h,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: 190.h,
              child: CupertinoDatePicker(
                initialDateTime: _selectedTime,
                mode: CupertinoDatePickerMode.time,
                use24hFormat: false,
                onDateTimeChanged: (val) {
                  setState(() {
                    _selectedTime = val;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _addOrUpdateTask() {
    if (_titleController.text.isNotEmpty) {
      String formattedTime = DateFormat('hh:mm a').format(_selectedTime);
      String formattedDate = DateFormat(
        'EEE, MMM d, yyyy',
      ).format(_selectedDate);

      if (widget.task != null) {
        widget.task!.title = _titleController.text;
        widget.task!.note = _noteController.text.isEmpty
            ? "No Description"
            : _noteController.text;
        widget.task!.date = formattedDate;
        widget.task!.time = formattedTime;

        context.read<TaskCubit>().updateTask(widget.task!);
        _showToast("Task updated successfully");
      } else {
        var newTask = Task(
          id: Random().nextInt(10000).toString(),
          title: _titleController.text,
          note: _noteController.text.isEmpty
              ? "No Description"
              : _noteController.text,
          date: formattedDate,
          time: formattedTime,
          isCompleted: false,
        );

        context.read<TaskCubit>().addTask(newTask);
      }

      Navigator.pop(context);
    } else {
      _showToast("Please enter a task title!", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeCubit cubit) => cubit.state);
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 1.h, width: 40.w, color: AppColors.grey),
                  Center(
                    child: CustomText(
                      text: widget.task != null ? "Edit Task" : "Add New Task",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      textColor: textColor,
                    ),
                  ),
                  Container(height: 1.h, width: 40.w, color: AppColors.grey),
                ],
              ),
              SizedBox(height: 20.h),
              CustomBorderlessField(
                controller: _titleController,
                hintText: "What are you planing😇?",
                fontSize: 18.sp,
                maxLines: 4,
                hintColor: Colors.grey,
                textColor: textColor,
              ),

              SizedBox(height: 10.h),
              Divider(color: Colors.grey[300], thickness: 1.h),
              SizedBox(height: 10.h),

              CustomBorderlessField(
                controller: _noteController,
                hintText: "Add Note",
                fontSize: 16.sp,
                maxLines: 2,
                icon: Icons.bookmark_border_rounded,
                hintColor: Colors.grey.shade600,
                textColor: textColor,
              ),

              SizedBox(height: 30.h),

              DateTimeSelector(
                label: "Time",
                value: DateFormat('hh:mm a').format(_selectedTime),
                onTap: _showTimePicker,
              ),

              SizedBox(height: 20.h),

              DateTimeSelector(
                label: "Date",
                value: DateFormat('MMM d, yyyy').format(_selectedDate),
                onTap: _showDatePicker,
              ),

              SizedBox(height: 60.h),

              Center(
                child: SizedBox(
                  width: 200.w,
                  height: 55.h,
                  child: CustomButton(
                    onTap: _addOrUpdateTask,
                    text: widget.task != null ? "Edit Task" : "Add Task",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
