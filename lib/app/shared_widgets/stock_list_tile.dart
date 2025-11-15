import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/data/models/stock_model.dart';
import 'package:monetra/app/utils/routes/app_routes.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';

class StockListTile extends StatelessWidget {
  final StockModel stock;
  const StockListTile({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tentukan warna berdasarkan untung/rugi
    final bool isProfit = stock.changePercent >= 0;
    final Color color = isProfit ? AppTheme.secondary : AppTheme.error;

    // Cek apakah ini saham Indo (untuk format harga & navigasi)
    final bool isIndoStock = stock.symbol.endsWith('.JK');

    // Format harga berdasarkan mata uang
    final String priceString = isIndoStock
        ? "Rp ${stock.price.toStringAsFixed(0)}"
        : "\$${stock.price.toStringAsFixed(2)}";

    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        // Ikon huruf depan
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          child: Text(
            stock.symbol.substring(0, 1),
            style: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Simbol
        title: Text(stock.symbol, style: TextStyle(fontWeight: FontWeight.bold)),

        // Nama panjang
        subtitle: Text(
          stock.longName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // Harga & Persentase
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              priceString,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              "${isProfit ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%",
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),

        // Aksi saat di-klik
        onTap: () {
          if (isIndoStock) {
            // Jika saham Indo, kirim simbol ke halaman detail (chart)
            final cleanSymbol = stock.symbol.replaceAll('.JK', '');

            Get.toNamed(
              AppRoutes.SAHAM_DETAIL.replaceFirst(':symbol', cleanSymbol),
            );
          } else {
            // Jika saham US (AAPL, dll), tampilkan pesan (sesuai logika kita sebelumnya)
            Get.snackbar(
              "Info",
              "Chart detail saat ini hanya tersedia untuk saham Indonesia (.JK).",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
      ),
    );
  }
}