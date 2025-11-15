import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/data/models/chart_model.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';

class StockDetailController extends GetxController {
  final DataRepository _repository = Get.find<DataRepository>();

  // State
  final isLoading = true.obs;
  final symbol = ''.obs;
  final chartModel = Rxn<ChartModel>();
  final chartSpots = <FlSpot>[].obs;

  // Style untuk chart
  late List<Color> gradientColors;
  late LineChartData chartData;

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil simbol yang dikirim dari halaman Saham
    symbol.value = Get.parameters['symbol'] ?? 'N/A';

    // 2. Siapkan warna chart
    gradientColors = [
      AppTheme.secondary, // Warna hijau
      AppTheme.primary,   // Warna biru
    ];

    // 3. Panggil API
    fetchChartData();
  }

  void fetchChartData() async {
    try {
      isLoading(true);

      // Panggil repository
      final data = await _repository.getChartData(symbol.value);
      chartModel.value = data;

      // 4. Proses data JSON menjadi data FlSpot untuk chart
      List<FlSpot> spots = [];
      if (data.chartTimestamp.isNotEmpty && data.chartClose.isNotEmpty) {
        for (int i = 0; i < data.chartTimestamp.length; i++) {
          // 'i' sebagai X (waktu)
          // 'price' sebagai Y (harga)
          // Kita filter data null jika ada
          if (data.chartClose[i] != null) {
            spots.add(FlSpot(i.toDouble(), data.chartClose[i]!));
          }
        }
        chartSpots.assignAll(spots);
        _updateChartData(); // Update data di chart
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat data chart: ${e.toString()}",
        backgroundColor: AppTheme.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Method untuk mengupdate data LineChart
  void _updateChartData() {
    chartData = LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false), // Sembunyikan label X dan Y
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (chartSpots.length - 1).toDouble(), // 1 tahun = 12 data (12 bulan)
      minY: chartSpots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) * 0.9, // 10% di bawah harga terendah
      maxY: chartSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.1, // 10% di atas harga tertinggi

      lineBarsData: [
        LineChartBarData(
          spots: chartSpots,
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false), // Sembunyikan titik
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }
  final jumlahLembarController = TextEditingController();

  @override
  void onClose() {
    jumlahLembarController.dispose();
    super.onClose();
  }

  Future<void> buyStock(double harga) async {
    final symbol = this.symbol.value;
    final jumlah = double.tryParse(jumlahLembarController.text.trim());

    if (jumlah == null || jumlah <= 0) {
      Get.snackbar("Error", "Jumlah lembar harus valid",
          backgroundColor: AppTheme.error, colorText: Colors.white);
      return;
    }

    final total = jumlah * harga;

    try {
      isLoading(true);
      final response = await _repository.createTransaksi(
        tipe: 'BUY_STOCK',
        jumlah: total,
        keterangan: 'Beli saham $symbol ($jumlah lembar @Rp${harga.toStringAsFixed(0)})',
        kodeAset: symbol,
      );

      if (response.statusCode == 201) {
        Get.snackbar("Sukses", "Pembelian saham berhasil",
            backgroundColor: AppTheme.secondary, colorText: Colors.white);
        jumlahLembarController.clear();
      } else {
        Get.snackbar("Gagal", "Transaksi gagal: ${response.data['message']}",
            backgroundColor: AppTheme.error, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal kirim transaksi: ${e.toString()}",
          backgroundColor: AppTheme.error, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
  Future<void> sellStock(double harga, int ownedLembar) async {
    final symbol = this.symbol.value;
    final jumlah = double.tryParse(jumlahLembarController.text.trim());

    if (jumlah == null || jumlah <= 0) {
      Get.snackbar("Error", "Jumlah lembar harus valid",
          backgroundColor: AppTheme.error, colorText: Colors.white);
      return;
    }

    // Validasi: tidak boleh jual lebih banyak dari yang dimiliki
    if (jumlah > ownedLembar) {
      Get.snackbar("Error", "Jumlah lembar melebihi kepemilikan ($ownedLembar lembar)",
          backgroundColor: AppTheme.error, colorText: Colors.white);
      return;
    }

    final total = jumlah * harga;

    try {
      isLoading(true);
      final response = await _repository.createTransaksi(
        tipe: 'SELL_STOCK',
        jumlah: total,
        keterangan: 'Jual saham $symbol ($jumlah lembar @Rp${harga.toStringAsFixed(0)})',
        kodeAset: symbol,
      );

      if (response.statusCode == 201) {
        Get.snackbar("Sukses", "Penjualan saham berhasil",
            backgroundColor: AppTheme.secondary, colorText: Colors.white);
        jumlahLembarController.clear();
      } else {
        Get.snackbar("Gagal", "Transaksi gagal: ${response.data['message']}",
            backgroundColor: AppTheme.error, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal kirim transaksi: ${e.toString()}",
          backgroundColor: AppTheme.error, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

}