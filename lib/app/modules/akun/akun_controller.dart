import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/services/auth_service.dart';
import 'package:monetra/app/services/settings_service.dart';
import 'package:monetra/app/utils/routes/app_routes.dart';

class AkunController extends GetxController {
  // Ambil service yang sudah kita buat
  final AuthService _authService = Get.find<AuthService>();
  final SettingsService _settingsService = Get.find<SettingsService>();

  // State untuk melacak status dark mode
  late RxBool isDarkMode;

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi state dark mode berdasarkan apa yang tersimpan
    isDarkMode = (_settingsService.getThemeMode() == ThemeMode.dark).obs;
  }

  // Fungsi untuk Logout
  void logout() {
    // Tampilkan dialog konfirmasi dulu
    Get.defaultDialog(
      title: "Logout",
      middleText: "Apakah Anda yakin ingin keluar dari akun Anda?",
      textConfirm: "Ya, Keluar",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      onConfirm: () {
        // Hapus token dan data user
        _authService.logout();
        // Arahkan ke Halaman Login (dan hapus semua halaman sebelumnya)
        Get.offAllNamed(AppRoutes.AUTH_LOGIN);
      },
    );
  }

  // Fungsi untuk ganti tema
  void switchTheme(bool value) {
    _settingsService.switchTheme();
    isDarkMode.value = value;
  }
}