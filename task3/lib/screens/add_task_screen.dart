import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:task3/core/constants/colors.dart';
import 'package:task3/core/widgets/custom_button.dart';
import 'package:task3/core/widgets/custom_text.dart';
import 'package:task3/core/widgets/custom_text_form_field.dart';
import 'package:task3/data/models/task_model.dart';
import 'dart:math';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('EEE, MMM d, yyyy').format(DateTime.now());
    _timeController.text = DateFormat('hh:mm a').format(DateTime.now());
  }

  Future<void> _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
        _dateController.text = DateFormat('EEE, MMM d, yyyy'
        ).format(_selectedDate!);
      });
    }
  }

  Future<void> _getTimeFromUser() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      final format = DateFormat('hh:mm a');

      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = format.format(dt);
      });
    }
  }

  void _addTask() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      var task = Task(
        id: Random().nextInt(10000).toString(),
        title: _titleController.text,
        note: _noteController.text,
        date: _dateController.text,
        time: _timeController.text,
        isCompleted: false,
      );

      var box = Hive.box<Task>('tasks');
      box.add(task);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomText(text: "Please enter title and note", textColor: Colors.white),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color inputFillColor = isDarkMode ? AppColors.darkContainerColor : Colors.grey[50]!;
    Color inputTextColor = isDarkMode ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 75.w,
                      height: 1.h,
                      decoration: const BoxDecoration(color: AppColors.grey),
                    ),
                    CustomText(
                      text: "Add New Task",
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      textColor: textColor,
                    ),
                    Container(
                      width: 75.w,
                      height: 1.h,
                      decoration: const BoxDecoration(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              CustomText(
                  text: "What are you planing😇?",
                  fontSize: 16.sp,
                  textColor: textColor
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _titleController,
                maxLines: 3,
                style: TextStyle(color: inputTextColor),
                decoration: InputDecoration(
                  hintText: "Enter task title",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  filled: true,
                  fillColor: inputFillColor,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Icon(Icons.bookmark_border, color: AppColors.primaryColor),
                  SizedBox(width: 10.w),
                  CustomText(text: "Add Note", fontSize: 16.sp, textColor: textColor),
                ],
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _noteController,
                style: TextStyle(color: inputTextColor),
                decoration: InputDecoration(
                  hintText: "Enter note",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  filled: true,
                  fillColor: inputFillColor,
                ),
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "Time", fontSize: 15.sp, textColor: textColor),
                  SizedBox(height: 5.h),
                  CustomTextFormField(
                    controller: _timeController,
                    onTap: _getTimeFromUser,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "Date", fontSize: 15.sp, textColor: textColor),
                  SizedBox(height: 5.h),
                  CustomTextFormField(controller: _dateController, onTap: _getDateFromUser),
                ],
              ),
              SizedBox(height: 50.h),
              Center(
                child: SizedBox(
                  width: 180.w,
                  height: 50.h,
                  child:
                  CustomButton(onTap: _addTask, text: "Add Task"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}