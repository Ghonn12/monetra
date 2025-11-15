import 'package:get/get.dart';
import 'package:monetra/app/data/models/transaksi_model.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';

class TransaksiController extends GetxController {
  final DataRepository _repository = Get.find<DataRepository>();

  final isLoading = false.obs;
  final transaksiList = <TransaksiModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransaksi();
  }

  // --- PERBAIKAN DI SINI ---
  // Pastikan 'async' ada. Ini akan mengubah return type dari 'void'
  // menjadi 'Future<void>', yang bisa di 'await'
  Future<void> fetchTransaksi() async {
    try {
      isLoading(true);
      // Panggil API
      var data = await _repository.getTransaksiHistory();
      transaksiList.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat riwayat transaksi: ${e.toString()}");
      print("❌ ERROR FETCH TRANSAKSI: $e");
    } finally {
      isLoading(false);
    }
  }
}