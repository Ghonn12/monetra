import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'transaksi_controller.dart';

class TransaksiView extends GetView<TransaksiController> {
  const TransaksiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Transaksi")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.transaksiList.isEmpty) {
          return const Center(
            child: Text("Belum ada transaksi", style: TextStyle(fontSize: 18)),
          );
        }

        return ListView.separated(
          itemCount: controller.transaksiList.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final trx = controller.transaksiList[index];
            return ListTile(
              leading: Icon(
                trx.tipe == 'DEPOSIT' ? Icons.arrow_downward : Icons.arrow_upward,
                color: trx.tipe == 'DEPOSIT' ? Colors.green : Colors.red,
              ),
              title: Text(trx.keterangan),
              subtitle: Text("Tanggal: ${trx.date}"),
              trailing: Text(
                "Rp ${trx.jumlah.toStringAsFixed(0)}",
                style: TextStyle(
                  color: trx.tipe == 'DEPOSIT' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
