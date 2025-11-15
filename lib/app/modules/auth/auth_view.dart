import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monetra/app/utils/routes/app_routes.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';
import 'auth_controller.dart';

// --- HALAMAN LOGIN (Diperbarui dengan Logo & UI Rapi) ---
class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text("Login ke Monetra"),
        automaticallyImplyLeading: false, // Sembunyikan tombol back
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- LOGO BARU ANDA ---
              Image.asset(
                'assets/images/logo.png',
                height: 140, // Sesuaikan ukurannya
              ),
              // ---
              SizedBox(height: 32),

              // --- TEXTFIELD EMAIL (Diperbarui) ---
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                  filled: true, // <-- Tambahkan ini
                  fillColor: Colors.white, // <-- Latar belakang putih
                  labelStyle: TextStyle(color: AppTheme.textDark.withOpacity(0.7)),
                  floatingLabelStyle: TextStyle(color: AppTheme.primary),
                  enabledBorder: OutlineInputBorder( // <-- Border lebih jelas
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // --- TEXTFIELD PASSWORD (Diperbarui) ---
              Obx(() => TextField(
                controller: controller.passwordController,
                obscureText: controller.isPasswordHidden.value,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(controller.isPasswordHidden.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () => controller.isPasswordHidden.toggle(),
                  ),
                  filled: true, // <-- Tambahkan ini
                  fillColor: Colors.white, // <-- Latar belakang putih
                  labelStyle: TextStyle(color: AppTheme.textDark.withOpacity(0.7)),
                  floatingLabelStyle: TextStyle(color: AppTheme.primary),
                  enabledBorder: OutlineInputBorder( // <-- Border lebih jelas
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              )),
              SizedBox(height: 32),

              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 3)
                    : Text("Login"),
              )),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.AUTH_REGISTER);
                },
                child: Text("Belum punya akun? Daftar di sini"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// --- HALAMAN REGISTER (Diperbarui dengan UI Rapi) ---
class RegisterView extends GetView<AuthController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text("Daftar Akun Baru")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- LOGO BARU ANDA ---
              Image.asset(
                'assets/images/logo.png',
                height: 140,
              ),
              // ---
              SizedBox(height: 32),

              // --- TEXTFIELD NAMA (Diperbarui) ---
              TextField(
                controller: controller.nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "Nama Lengkap",
                  prefixIcon: Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: AppTheme.textDark.withOpacity(0.7)),
                  floatingLabelStyle: TextStyle(color: AppTheme.primary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // --- TEXTFIELD EMAIL (Diperbarui) ---
              TextField(
                controller: controller.registerEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: AppTheme.textDark.withOpacity(0.7)),
                  floatingLabelStyle: TextStyle(color: AppTheme.primary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // --- TEXTFIELD PASSWORD (Diperbarui) ---
              Obx(() => TextField(
                controller: controller.registerPasswordController,
                obscureText: controller.isPasswordHidden.value,
                decoration: InputDecoration(
                  labelText: "Password (Min 6 Karakter)",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(controller.isPasswordHidden.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () => controller.isPasswordHidden.toggle(),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: AppTheme.textDark.withOpacity(0.7)),
                  floatingLabelStyle: TextStyle(color: AppTheme.primary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              )),
              SizedBox(height: 32),

              Obx(() => ElevatedButton(
                onPressed:
                controller.isLoading.value ? null : controller.register,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: controller.isLoading.value
                    ? CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 3)
                    : Text("Daftar Akun"),
              )),

              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Get.back(); // Kembali ke Login
                },
                child: Text("Sudah punya akun? Login di sini"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// ---

// --- HALAMAN KYC (Tetap sama) ---
class KycView extends GetView<AuthController> {
  const KycView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text("Verifikasi Akun"),
        automaticallyImplyLeading: false, // Sembunyikan back
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => controller.logout(),
            tooltip: "Logout",
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Langkah Terakhir!",
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "Untuk mengaktifkan fitur finansial, kami perlu memverifikasi identitas Anda. Harap upload foto KTP dan foto selfie Anda.",
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 32),
            Text("1. Foto KTP", style: theme.textTheme.titleMedium),
            SizedBox(height: 8),
            Obx(() => _buildImagePickerBox(
              context: context,
              imageFile: controller.ktpImage.value,
              onTap: () => _showPickImageModal(context,
                      (source) => controller.pickImage(source, controller.ktpImage)),
            )),
            SizedBox(height: 24),
            Text("2. Foto Selfie dengan KTP", style: theme.textTheme.titleMedium),
            SizedBox(height: 8),
            Obx(() => _buildImagePickerBox(
              context: context,
              imageFile: controller.selfieImage.value,
              onTap: () => _showPickImageModal(
                  context,
                      (source) =>
                      controller.pickImage(source, controller.selfieImage)),
            )),
            SizedBox(height: 40),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.uploadKycFiles,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: controller.isLoading.value
                  ? CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 3)
                  : Text("Upload dan Verifikasi"),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerBox(
      {required BuildContext context,
        File? imageFile,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, // Ganti ke putih agar kontras
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300), // Border lebih jelas
          image: imageFile != null
              ? DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover)
              : null,
        ),
        child: imageFile == null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined,
                  color: Colors.grey.shade600, size: 40),
              SizedBox(height: 8),
              Text("Klik untuk pilih gambar",
                  style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
        )
            : null,
      ),
    );
  }

  void _showPickImageModal(BuildContext context, Function(ImageSource) onPick) {
    Get.bottomSheet(
      Container(
        color: AppTheme.background, // Gunakan warna tema
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Pilih dari Galeri'),
              onTap: () {
                onPick(ImageSource.gallery);
                Get.back(); // Tutup bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Ambil dari Kamera'),
              onTap: () {
                onPick(ImageSource.camera);
                Get.back(); // Tutup bottom sheet
              },
            ),
          ],
        ),
      ),
    );
  }
}