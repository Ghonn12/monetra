// lib/app/modules/splash/splash_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'splash_controller.dart';
import '../../utils/theme/app_theme.dart'; // Pastikan ini di-import

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();

    return Scaffold(
      // --- GANTI INI ---
      // backgroundColor: Colors.white,

      // MENJADI INI:
      backgroundColor: AppTheme.background, // <- Otomatis pakai #F4F8F9

      body: Center(
        child: Container(
          width: Get.width * 0.6,
          child: Lottie.asset(
            'assets/lottie/animation.json',
            repeat: true,
          ),
        ),
      ),
    );
  }
}