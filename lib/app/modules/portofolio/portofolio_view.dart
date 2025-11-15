import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';
import 'portofolio_controller.dart';

class PortofolioView extends GetView<PortofolioController> {
  const PortofolioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Portofolio Aset")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Total Aset
              Text("Total Nilai Aset", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              Text(
                "Rp ${controller.totalSemuaAset.value.toStringAsFixed(0)}",
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // 2. Donut Chart Alokasi Aset
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 60,
                    sections: [
                      PieChartSectionData(
                        value: controller.totalTabungan.value,
                        title: "${((controller.totalTabungan.value / controller.totalSemuaAset.value) * 100).toStringAsFixed(0)}%",
                        color: AppTheme.primary,
                        radius: 80,
                        titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      PieChartSectionData(
                        value: controller.totalSaham.value,
                        title: "Saham",
                        color: AppTheme.secondary,
                        radius: 80,
                        titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      PieChartSectionData(
                        value: controller.totalCrypto.value,
                        title: "Crypto",
                        color: AppTheme.warning,
                        radius: 80,
                        titleStyle: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 3. Detail List Aset
              Text("Rincian Aset", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildAsetCard("Tabungan", controller.totalTabungan.value, Icons.savings, AppTheme.primary),
              _buildAsetCard("Saham", controller.totalSaham.value, Icons.show_chart, AppTheme.secondary),
              _buildAsetCard("Crypto", controller.totalCrypto.value, Icons.currency_bitcoin, AppTheme.warning),

              const SizedBox(height: 24),
              Text("Detail Portofolio Saham", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...controller.portofolioSaham.map((s) => Card(
                child: ListTile(
                  title: Text("${s.stockSymbol} - ${s.jumlahLembar} lembar"),
                  subtitle: Text("Harga rata-rata: Rp ${s.hargaBeliRataRata.toStringAsFixed(0)}"),
                  trailing: Text(
                    "Rp ${(s.jumlahLembar * s.hargaBeliRataRata).toStringAsFixed(0)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAsetCard(String title, double value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          "Rp ${value.toStringAsFixed(0)}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
