import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/shared_widgets/stock_list_tile.dart';
import 'saham_controller.dart';

class SahamView extends GetView<SahamController> {
  const SahamView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pasar Saham (IHSG & Global)")),
      body: Obx(() {
        // Tampilkan loading spinner
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Tampilkan list jika data sudah ada
        if (controller.stockList.isEmpty) {
          return Center(child: Text("Tidak ada data saham."));
        }

        // Gunakan ListView.builder untuk menampilkan data
        return ListView.builder(
          padding: EdgeInsets.only(top: 8, bottom: 80), // Padding agar tidak tertutup FAB
          itemCount: controller.stockList.length,
          itemBuilder: (context, index) {
            final stock = controller.stockList[index];
            // Gunakan widget kustom StockListTile
            return StockListTile(stock: stock);
          },
        );
      }),

      // Tombol Refresh seperti di screenshot Anda
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.fetchStockData(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}