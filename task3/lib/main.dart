import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task3/core/constants/colors.dart';
import 'package:task3/data/models/task_model.dart';
import 'package:task3/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/task_cubit.dart';
import 'cubits/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  await Hive.openBox('settings');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    final settingsBox = Hive.box('settings');
    isDarkMode = settingsBox.get('isDarkMode', defaultValue: false);
  }

  void updateTheme(bool value) {
    setState(() {
      isDarkMode = value;
      Hive.box('settings').put('isDarkMode', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => TaskCubit()..getTasks()),
            BlocProvider(create: (context) => ThemeCubit()),
          ],
          child: BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDarkMode) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Task App',
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

                // Light Theme
                theme: ThemeData(
                  brightness: Brightness.light,
                  primaryColor: AppColors.primaryColor,
                  scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
                  useMaterial3: true,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: AppColors.white,
                    iconTheme: IconThemeData(color: Colors.black),
                    titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Dark Theme
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: AppColors.primaryColor,
                  scaffoldBackgroundColor: AppColors.darkScaffoldColor,
                  useMaterial3: true,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: AppColors.darkScaffoldColor,
                    iconTheme: IconThemeData(color: Colors.white),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  dialogTheme: DialogThemeData(
                    backgroundColor: AppColors.darkContainerColor,
                  ),
                ),
                home: HomeScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
