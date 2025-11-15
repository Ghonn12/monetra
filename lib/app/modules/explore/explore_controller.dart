import 'package:get/get.dart';
import 'package:monetra/app/data/models/crypto_model.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';

class ExploreController extends GetxController {
  final DataRepository _repository = Get.find<DataRepository>();

  final isLoading = false.obs;
  final cryptoList = <CryptoModel>[].obs;

  final List<String> _cryptoSymbols = [
    'BTC', 'ETH', 'SOL', 'XRP', 'DOGE', 'ADA', 'LTC'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchCryptoData();
  }

  void fetchCryptoData() async {
    try {
      isLoading(true);
      List<CryptoModel> cryptos = [];

      for (String symbol in _cryptoSymbols) {
        try {
          // 🔗 Ambil data asli dari repository
          final crypto = await _repository.getCryptoData(symbol);
          cryptos.add(crypto);
        } catch (e) {
          // 🔥 Fallback dummy data kalau API gagal / limit
          cryptos.add(
            CryptoModel(
              symbol: symbol,
              name: "Dummy $symbol",
              priceUsd: 1000.0 + cryptos.length * 50, // harga dummy
            ),
          );
        }
      }

      cryptoList.assignAll(cryptos);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data crypto: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
}
