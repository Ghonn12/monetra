import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';
import 'stock_detail_controller.dart';

class StockDetailView extends GetView<StockDetailController> {
  const StockDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.symbol.value)),
      ),
      body: Obx(() {
        // Tampilkan loading Lottie
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Tampilkan jika data gagal
        if (controller.chartModel.value == null) {
          return Center(child: Text("Gagal memuat data chart."));
        }

        final chart = controller.chartModel.value!;

        // Tampilkan data dan chart
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chart.symbol,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      chart.exchangeName,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Rp ${chart.regularMarketPrice?.toStringAsFixed(0) ?? 'N/A'}",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // --- CHART ---
              SizedBox(height: 30),
              AspectRatio(
                aspectRatio: 1.70,
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0, left: 12.0),
                  child: controller.chartSpots.isEmpty
                      ? Center(child: Text("Data chart tidak tersedia"))
                      : LineChart(
                    controller.chartData, // Ambil data dari controller
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Beli Saham", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    TextField(
                      controller: controller.jumlahLembarController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Jumlah Lembar",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: Icon(Icons.shopping_cart_outlined),
                      label: Text("Beli Sekarang"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        final harga = controller.chartModel.value?.regularMarketPrice ?? 0;
                        controller.buyStock(harga);
                      },
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.sell_outlined),
                      label: Text("Jual Saham"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        final harga = controller.chartModel.value?.regularMarketPrice ?? 0;
                        final ownedLembar = 100; // contoh: ambil dari portofolio user
                        controller.sellStock(harga, ownedLembar);
                      },
                    ),
                  ],
                ),
              ),

              // ... (Tambahkan UI lain di sini, cth: tombol Beli/Jual)
            ],
          ),
        );
      }),
    );
  }
}