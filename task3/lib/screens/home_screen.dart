import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task3/core/constants/colors.dart';
import 'package:task3/core/widgets/custom_task_item.dart';
import 'package:task3/core/widgets/custom_text.dart';
import 'package:task3/data/models/task_model.dart';
import 'package:task3/screens/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged;
  const HomeScreen({super.key, this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Box<Task> taskBox = Hive.box<Task>('tasks');
  final Box settingsBox = Hive.box('settings');

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = settingsBox.get('isDarkMode', defaultValue: false);
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
      widget.onThemeChanged?.call(isDarkMode);
    });
  }

  void _deleteAllTasks() {
    if (taskBox.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomText(text: "There are no tasks to delete!", textColor: Colors.white),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        Color dialogTextColor = isDarkMode ? Colors.white : Colors.black;

        return AlertDialog(
          title: Text("Delete All", style: TextStyle(color: dialogTextColor)),
          content: Text("Are you sure you want to delete all tasks?", style: TextStyle(color: dialogTextColor)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                taskBox.clear();
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color subTextColor = isDarkMode ? Colors.white70 : Colors.black87;
    Color iconColor = isDarkMode ? Colors.white : AppColors.secondaryColor;

    var tasks = taskBox.values.toList().cast<Task>();
    int totalTasks = tasks.length;
    int completedTasks = tasks.where((task) => task.isCompleted).length;
    double percent = totalTasks == 0 ? 0 : completedTasks / totalTasks;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskScreen()));
          setState(() {});
        },
        child: Icon(Icons.add, size: 24.sp, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // TOP ICONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _toggleTheme,
                    child: Icon(
                      isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_rounded,
                      color: isDarkMode ? Colors.orangeAccent : AppColors.primaryColor,
                      size: 30.sp,
                    ),
                  ),
                  IconButton(
                    onPressed: _deleteAllTasks,
                    icon: Icon(Icons.delete_outline, color: iconColor, size: 30.sp),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // CIRCLE PERCENT + TEXT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularPercentIndicator(
                    radius: 30.0,
                    lineWidth: 5.0,
                    percent: percent,
                    animation: true,
                    animationDuration: 800,
                    animateFromLastPercent: true,
                    animateToInitialPercent: true,
                    center: CustomText(
                      text: "${(percent * 100).toStringAsFixed(1)}%",
                      fontSize: 12.sp,
                      textColor: isDarkMode ? Colors.white : AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    progressColor: AppColors.primaryColor,
                    backgroundColor: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "My Tasks",
                        fontSize: 48.sp,
                        fontWeight: FontWeight.w400,
                        textColor: textColor,
                      ),
                      SizedBox(height: 5.h),
                      CustomText(
                        text: "$completedTasks of $totalTasks tasks",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        textColor: subTextColor,
                      )
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20.h),
              Row(
                children: [
                  SizedBox(width: 100.w),
                  Container(width: 220.w, height: 1.h, color: AppColors.grey),
                ],
              ),
              SizedBox(height: 20.h),

              // TASKS LIST
              Expanded(
                child: tasks.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon.png',
                        width: 150.w,
                        height: 150.h,
                        errorBuilder: (c, e, s) =>
                            Icon(Icons.paste, size: 100.sp, color: AppColors.primaryColor),
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                        text: 'You Have Done All Tasks! 👌',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        textColor: textColor,
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks.reversed.toList()[index];
                    final taskKey = task.key;

                    return Dismissible(
                      key: Key(task.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.w),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (dir) {
                        taskBox.delete(taskKey);
                        setState(() {});
                      },
                      confirmDismiss: (direction) async {
                        Color dialogText = isDarkMode ? Colors.white : Colors.black;
                        return showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Delete Task", style: TextStyle(color: dialogText)),
                            content: Text("Are you sure you want to delete this task?",
                                style: TextStyle(color: dialogText)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: CustomText(text:"Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: CustomText(text: "Delete", textColor: Colors.red),
                              ),
                            ],
                          ),
                        );
                      },
                      child: CustomTaskItem(
                        task: task,
                        onTap: () {
                          task.isCompleted = !task.isCompleted;
                          task.save();
                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
