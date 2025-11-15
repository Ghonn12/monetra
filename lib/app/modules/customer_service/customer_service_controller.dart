import 'package:get/get.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
class CustomerServiceController extends GetxController {

  // Ganti dengan nomor WhatsApp Anda (dengan kode negara, tanpa +)
  final String waNumber = "6281234567890";
  final String waMessage = "Halo, saya butuh bantuan terkait aplikasi Monetra.";

  void launchWhatsApp() async {
    // Buat URL
    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/$waNumber?text=${Uri.encodeComponent(waMessage)}",
    );

    try {
      // Coba buka URL
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        _showError("Tidak dapat membuka WhatsApp.");
      }
    } catch (e) {
      _showError("Terjadi kesalahan: $e");
    }
  }

  void _showError(String message) {
    Get.snackbar("Error", message,
        backgroundColor: AppTheme.error, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }
}