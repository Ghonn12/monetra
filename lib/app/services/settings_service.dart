import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsService extends GetxService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode getThemeMode() {
    return _isDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool _isDarkMode() {
    return _box.read(_key) ?? false; // Default false (light mode)
  }

  void switchTheme() {
    bool isDark = _isDarkMode();
    _box.write(_key, !isDark);
    Get.changeThemeMode(!isDark ? ThemeMode.dark : ThemeMode.light);
  }
}