import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/modules/home/home_view.dart';
import 'package:monetra/app/modules/portofolio/portofolio_view.dart';
import 'package:monetra/app/modules/saham/saham_view.dart';
import 'package:monetra/app/modules/tabungan/tabungan_view.dart';
import 'package:monetra/app/modules/transaksi/transaksi_view.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // List halaman sesuai urutan BottomNav
    final List<Widget> pages = [
      TabunganView(),     // index 0
      SahamView(),        // index 1
      TransaksiView(),    // index 2
      PortofolioView(),   // index 3
      HomeView(),         // index 4 (Pusat Navigasi)
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: pages,
      )),

      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.tabIndex.value,
        onTap: controller.changeTabIndex,
        // (Style sudah diatur di AppTheme)
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Tabungan'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Saham'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Portofolio'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
        ],
      )),
    );
  }
}