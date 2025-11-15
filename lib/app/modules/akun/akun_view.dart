import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';
import '../../utils/routes/app_routes.dart';
import 'akun_controller.dart';

class AkunView extends GetView<AkunController> {
  const AkunView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Akun & Pengaturan")),
      body: ListView(
        children: [
          // Info Profil (Placeholder)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                  child: Icon(Icons.person_outline, size: 30, color: AppTheme.primary),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nama User", // Nanti kita ambil dari AuthService
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("email@user.com"), // Nanti kita ambil dari AuthService
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1),

          // Pengaturan Tema
          Obx(() => SwitchListTile(
            title: Text("Mode Gelap (Dark Mode)"),
            secondary: Icon(controller.isDarkMode.value ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
            value: controller.isDarkMode.value,
            onChanged: (value) {
              controller.switchTheme(value);
            },
          )),

          ListTile(
            leading: Icon(Icons.shield_outlined),
            title: Text("Keamanan Akun"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Nanti ke halaman ganti password/PIN
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text("Notifikasi"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text("Pusat Bantuan (CS)"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Arahkan ke halaman C. Service yang sudah kita buat
              Get.toNamed(AppRoutes.CUSTOMER_SERVICE);
            },
          ),

          Divider(height: 1, indent: 16, endIndent: 16),

          // Tombol Logout
          ListTile(
            leading: Icon(Icons.logout, color: AppTheme.error),
            title: Text("Logout", style: TextStyle(color: AppTheme.error)),
            onTap: () {
              controller.logout();
            },
          ),
        ],
      ),
    );
  }
}