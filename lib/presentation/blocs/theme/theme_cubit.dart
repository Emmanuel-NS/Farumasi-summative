import 'package:flutter/material.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart'; // REMOVED
import 'package:shared_preferences/shared_preferences.dart';

// Since we haven't added hydrated_bloc, we'll use standard Cubit + SharedPreferences manually
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null) {
      emit(ThemeMode.values[themeIndex]);
    }
  }

  void updateTheme(ThemeMode themeMode) async {
    emit(themeMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themeMode.index);
  }

  void toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    updateTheme(newMode);
  }
}
