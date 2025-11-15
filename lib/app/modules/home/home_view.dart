import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/modules/dashboard/dashboard_controller.dart'; // <-- Import DashboardController
import 'package:monetra/app/shared_widgets/promo_banner_carousel.dart';
import 'package:monetra/app/utils/routes/app_routes.dart';
import 'package:monetra/app/utils/theme/app_theme.dart'; // <-- Import Tema
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monetra"),
        // leading: Padding( // Logo kecil di App Bar (Opsional)
        //   padding: const EdgeInsets.all(8.0),
        //   child: Image.asset('assets/images/logo.png', color: Colors.white),
        // ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () => Get.toNamed(AppRoutes.AKUN),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Promo Banner Dinamis ---
            Obx(() {
              if (controller.isBannerLoading.value) {
                return Container(
                  height: 180,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }
              return PromoBannerCarousel(banners: controller.bannerList);
            }),

            // --- Menu Navigasi ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMenuIcon(
                      Icons.explore_outlined,
                      "Explore",
                          () => Get.toNamed(AppRoutes.EXPLORE) // <-- Berfungsi
                  ),
                  _buildMenuIcon(
                      Icons.history_edu_outlined,
                      "History",
                          () => Get.toNamed(AppRoutes.TRANSAKSI) // <-- SEKARANG BERFUNGSI
                  ),
                  _buildMenuIcon(
                      Icons.headset_mic_outlined,
                      "C. Service",
                          () => Get.toNamed(AppRoutes.CUSTOMER_SERVICE) // <-- SEKARANG BERFUNGSI
                  ),
                  _buildMenuIcon(
                      Icons.person_outline,
                      "Akun",
                          () => Get.toNamed(AppRoutes.AKUN) // <-- Berfungsi
                  ),
                  _buildMenuIcon(
                      Icons.bar_chart_outlined,
                      "Pasar Saham",
                      // Pindah ke Tab Saham (index 1)
                          () => Get.find<DashboardController>().changeTabIndex(1) // <-- SEKARANG BERFUNGSI
                  ),
                  _buildMenuIcon(
                      Icons.calculate_outlined,
                      "Auto Budget",
                          () => Get.toNamed(AppRoutes.AUTO_BUDGET) // <-- SEKARANG BERFUNGSI
                  ),
                  _buildMenuIcon(
                      Icons.account_balance_wallet_outlined,
                      "Portofolio",
                      // Pindah ke Tab Portofolio (index 3)
                          () => Get.find<DashboardController>().changeTabIndex(3) // <-- SEKARANG BERFUNGSI
                  ),
                  _buildMenuIcon(
                      Icons.settings_outlined,
                      "Setting",
                          () => Get.toNamed(AppRoutes.AKUN) // <-- Berfungsi
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Kustom untuk Ikon Menu
  Widget _buildMenuIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(icon, color: AppTheme.primary, size: 30),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}