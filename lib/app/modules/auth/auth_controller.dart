import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monetra/app/utils/routes/app_routes.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/auth_service.dart';

class AuthController extends GetxController {
  // States
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  // Text Controllers (Login)
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // --- TAMBAHKAN TEXT CONTROLLERS REGISTER ---
  final nameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();

  // Services & Repos
  final AuthRepository _repository = AuthRepository();
  final AuthService _authService = Get.find<AuthService>();

  // KYC States
  final ImagePicker _picker = ImagePicker();
  final ktpImage = Rxn<File>();
  final selfieImage = Rxn<File>();

  @override
  void onClose() {
    // Dispose semua controller
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    super.onClose();
  }

  // --- LOGIN ---
  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Email dan password tidak boleh kosong");
      return;
    }

    isLoading(true);
    try {
      final response = await _repository.login(email, password);
      if (response.statusCode == 200) {
        final data = response.data;
        await _authService.saveLoginData(data);

        Get.snackbar("Sukses", "Login berhasil!",
            backgroundColor: AppTheme.secondary, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);

        String statusKyc = data['status_kyc'];
        if (statusKyc == "NOT_VERIFIED") {
          Get.offAllNamed(AppRoutes.AUTH_KYC);
        } else {
          Get.offAllNamed(AppRoutes.DASHBOARD);
        }
      } else {
        final errorMessage = response.data['messages']['error'] ?? "Terjadi kesalahan";
        _showError(errorMessage);
      }
    } catch (e) {
      _showError("Gagal terhubung ke server.");
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }

  // --- TAMBAHKAN FUNGSI REGISTER BARU ---
  void register() async {
    String name = nameController.text.trim();
    String email = registerEmailController.text.trim();
    String password = registerPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError("Semua field tidak boleh kosong");
      return;
    }
    if (password.length < 6) {
      _showError("Password minimal 6 karakter");
      return;
    }
    if (!GetUtils.isEmail(email)) {
      _showError("Format email tidak valid");
      return;
    }

    isLoading(true);
    try {
      final response = await _repository.register(name, email, password);

      if (response.statusCode == 201) { // 201 Created
        Get.snackbar("Sukses", "Registrasi berhasil! Silakan Login.",
            backgroundColor: AppTheme.secondary, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);

        // Bersihkan field dan kembali ke halaman login
        nameController.clear();
        registerEmailController.clear();
        registerPasswordController.clear();
        Get.offNamed(AppRoutes.AUTH_LOGIN); // offNamed agar tidak bisa back
      } else {
        // Gagal (cth: 400 Email sudah terdaftar)
        final messages = response.data['messages'];
        String errorMessage = "Registrasi Gagal";
        if (messages != null && messages is Map && messages.containsKey('email')) {
          errorMessage = messages['email'].toString(); // Ambil pesan error
        }
        _showError(errorMessage);
      }
    } catch (e) {
      _showError("Gagal terhubung ke server.");
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }
  // ---

  // --- KYC IMAGE PICKER ---
  Future<void> pickImage(ImageSource source, Rx<File?> imageFile) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  // --- KYC UPLOAD ---
  void uploadKycFiles() async {
    if (ktpImage.value == null || selfieImage.value == null) {
      _showError("Harap pilih Foto KTP dan Foto Selfie");
      return;
    }

    isLoading(true);
    try {
      final response = await _repository.uploadKyc(ktpImage.value!, selfieImage.value!);

      if (response.statusCode == 200) {
        final data = response.data;
        await _authService.updateKycStatus(data['status_kyc']); // PENDING

        Get.snackbar("Sukses", "Data KYC berhasil di-upload, sedang diverifikasi.",
            backgroundColor: AppTheme.secondary, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);

        Get.offAllNamed(AppRoutes.DASHBOARD);
      } else {
        final errorMessage = response.data['messages']?.toString() ?? "Upload gagal";
        _showError(errorMessage);
      }
    } catch (e) {
      _showError("Gagal terhubung ke server.");
    } finally {
      isLoading(false);
    }
  }

  // --- LOGOUT ---
  void logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.AUTH_LOGIN);
  }

  // Helper
  void _showError(String message) {
    Get.snackbar("Error", message,
        backgroundColor: AppTheme.error, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }
}