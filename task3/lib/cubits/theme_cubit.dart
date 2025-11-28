import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false) {
    _loadTheme();
  }

  final Box settingsBox = Hive.box('settings');

  void _loadTheme() {
    bool isDarkMode = settingsBox.get('isDarkMode', defaultValue: false);
    emit(isDarkMode);
  }

  void toggleTheme() {
    bool newTheme = !state;
    settingsBox.put('isDarkMode', newTheme);
    emit(newTheme);
  }
}