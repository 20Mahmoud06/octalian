import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:task3/core/constants/colors.dart';
import 'package:task3/core/widgets/custom_task_item.dart';
import 'package:task3/core/widgets/custom_text.dart';
import 'package:task3/screens/add_task_screen.dart';
import 'package:task3/cubits/task_cubit.dart';
import 'package:task3/cubits/task_state.dart';
import 'package:task3/cubits/theme_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
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

  void _deleteAllTasks(BuildContext context) {
    final state = context.read<TaskCubit>().state;
    if (state is TaskLoaded && state.tasks.isEmpty) {
      _showToast("There are no tasks to delete!", isError: true);
      return;
    }

    PanaraConfirmDialog.show(
      context,
      title: "Delete All Tasks",
      message: "Are you sure you want to permanently delete all tasks?",
      confirmButtonText: "Delete",
      cancelButtonText: "Cancel",
      panaraDialogType: PanaraDialogType.error,
      barrierDismissible: false,
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () {
        context.read<TaskCubit>().deleteAllTasks();

        Navigator.pop(context);

        _showToast("All tasks deleted successfully");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        Color textColor = isDarkMode ? Colors.white : Colors.black;
        Color subTextColor = isDarkMode ? Colors.white70 : Colors.black87;
        Color iconColor = isDarkMode ? Colors.white : AppColors.secondaryColor;

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTaskScreen()),
              );
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
                        onTap: () {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        child: Icon(
                          isDarkMode
                              ? Icons.wb_sunny_rounded
                              : Icons.nightlight_rounded,
                          color: isDarkMode
                              ? Colors.orangeAccent
                              : AppColors.primaryColor,
                          size: 30.sp,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _deleteAllTasks(context),
                        icon: Icon(
                          Icons.delete_outline,
                          color: iconColor,
                          size: 30.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  Expanded(
                    child: BlocConsumer<TaskCubit, TaskState>(
                      listener: (context, state) {
                        if (state is TaskError) {
                          _showToast(state.message, isError: true);
                        }
                      },
                      builder: (context, state) {
                        if (state is TaskLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is TaskLoaded) {
                          var tasks = state.tasks;
                          int totalTasks = tasks.length;
                          int completedTasks = tasks
                              .where((task) => task.isCompleted)
                              .length;
                          double percent = totalTasks == 0
                              ? 0
                              : completedTasks / totalTasks;

                          return Column(
                            children: [
                              // CIRCLE PERCENT + TEXT
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                      text:
                                          "${(percent * 100).toStringAsFixed(1)}%",
                                      fontSize: 12.sp,
                                      textColor: isDarkMode
                                          ? Colors.white
                                          : AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    progressColor: AppColors.primaryColor,
                                    backgroundColor: isDarkMode
                                        ? Colors.grey[700]!
                                        : Colors.grey[200]!,
                                    circularStrokeCap: CircularStrokeCap.round,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "My Tasks",
                                        fontSize: 48.sp,
                                        fontWeight: FontWeight.w400,
                                        textColor: textColor,
                                      ),
                                      SizedBox(height: 5.h),
                                      CustomText(
                                        text:
                                            "$completedTasks of $totalTasks tasks",
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        textColor: subTextColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  SizedBox(width: 100.w),
                                  Container(
                                    width: 220.w,
                                    height: 1.h,
                                    color: AppColors.grey,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              // TASKS LIST
                              Expanded(
                                child: tasks.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Lottie.asset(
                                              'assets/1.json',
                                              width: 200.w,
                                              height: 200.h,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(height: 10.h),
                                            CustomText(
                                              text:
                                                  'You Have Done All Tasks! 👌',
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
                                          final task = tasks.reversed
                                              .toList()[index];

                                          return Dismissible(
                                            key: Key(task.id),
                                            background: Container(
                                              color: Colors.red,
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(
                                                right: 20.w,
                                              ),
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                            direction:
                                                DismissDirection.endToStart,
                                            onDismissed: (dir) {
                                              context
                                                  .read<TaskCubit>()
                                                  .deleteTask(task);
                                              _showToast("Task deleted");
                                            },
                                            confirmDismiss: (direction) async {
                                              final Completer<bool> completer =
                                                  Completer<bool>();
                                              PanaraConfirmDialog.show(
                                                context,
                                                title: "Delete Task",
                                                message:
                                                    "Are you sure you want to delete this task?",
                                                confirmButtonText: "Delete",
                                                cancelButtonText: "Cancel",
                                                panaraDialogType:
                                                    PanaraDialogType.error,
                                                barrierDismissible: false,
                                                onTapCancel: () {
                                                  Navigator.pop(context);
                                                  completer.complete(false);
                                                },
                                                onTapConfirm: () {
                                                  Navigator.pop(context);
                                                  completer.complete(true);
                                                },
                                              );
                                              return completer.future;
                                            },
                                            child: GestureDetector(
                                              onLongPress: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        AddTaskScreen(
                                                          task: task,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: CustomTaskItem(
                                                task: task,
                                                onTap: () {
                                                  task.isCompleted =
                                                      !task.isCompleted;
                                                  context
                                                      .read<TaskCubit>()
                                                      .updateTask(task);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
