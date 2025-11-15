import 'package:get/get.dart';
import 'package:monetra/app/data/models/saving_model.dart';
import 'package:monetra/app/data/models/portofolio_model.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';
import 'package:collection/collection.dart';

class PortofolioController extends GetxController {
  final DataRepository _repository = Get.find<DataRepository>();

  final savings = <SavingModel>[].obs;
  final portofolioSaham = <PortofolioModel>[].obs;
  int getOwnedLembar(String symbol) {
    final item = portofolioSaham.firstWhereOrNull(
          (p) => p.stockSymbol == symbol,
    );
    return item?.jumlahLembar ?? 0;
  }
  final isLoading = false.obs;

  final totalSaham = 0.0.obs;
  final totalCrypto = 0.0.obs;
  final totalTabungan = 0.0.obs;
  final totalSemuaAset = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    try {
      isLoading(true);

      // 1. Ambil data tabungan
      var savingData = await _repository.getSavings();
      savings.assignAll(savingData);

      double tempTotalTabungan = 0;
      for (var s in savingData) {
        tempTotalTabungan += s.currentAmount;
      }
      totalTabungan.value = tempTotalTabungan;

      // 2. Ambil data portofolio saham
      var sahamData = await _repository.getPortofolio();
      portofolioSaham.assignAll(sahamData);

      double tempTotalSaham = 0;
      for (var s in sahamData) {
        tempTotalSaham += s.jumlahLembar * s.hargaBeliRataRata;
      }
      totalSaham.value = tempTotalSaham;

      // 3. Ambil data crypto (contoh, bisa dari API lain)
      var cryptoData = await _repository.getCryptoPortofolio();
      double tempTotalCrypto = 0;
      for (var c in cryptoData) {
        tempTotalCrypto += c.priceUsd; // atau currentValue kalau API mengembalikan nilai total
      }
      totalCrypto.value = tempTotalCrypto;

      // 4. Hitung total semua aset
      totalSemuaAset.value = totalTabungan.value + totalSaham.value + totalCrypto.value;
    } finally {
      isLoading(false);
    }
  }

}
