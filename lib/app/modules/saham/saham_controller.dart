import 'package:get/get.dart';
import 'package:monetra/app/data/models/stock_model.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';

class SahamController extends GetxController {
  final DataRepository _repository = Get.find<DataRepository>();

  final isLoading = false.obs;
  final stockList = <StockModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStockData();
  }

  void fetchStockData() async {
    try {
      isLoading(true);
      print("\n==============================");
      print("📈 FETCH STOCK DATA DIPANGGIL");

      // 1. Daftar simbol manual (contoh: 5 Indo + 4 US)
      final List<String> indoSymbols = ["BBCA.JK", "BMRI.JK", "TLKM.JK", "BBRI.JK", "ASII.JK"];
      final List<String> usSymbols   = [ "MSFT", "TSLA", "GOOGL", "AMZN"];

      List<StockModel> fetchedStocks = [];

      // 2. Fetch data saham Indonesia (Yahoo endpoint)
      for (String symbol in indoSymbols) {
        print("➡️ AMBIL DATA SAHAM INDO: $symbol");
        final stock = await _repository.getIndoStock(symbol);
        fetchedStocks.add(stock);
        print("✅ BERHASIL AMBIL INDO: ${stock.symbol}");
      }

      // 3. Fetch data saham US (AlphaVantage endpoint)
      for (String symbol in usSymbols) {
        print("➡️ AMBIL DATA SAHAM US: $symbol");
        final stock = await _repository.getUsStock(symbol);
        fetchedStocks.add(stock);
        print("✅ BERHASIL AMBIL US: ${stock.symbol}");
      }

      // 4. Assign ke observable list
      stockList.assignAll(fetchedStocks);
      print("📦 STOCKLIST TERISI: ${stockList.length} item");
      print("==============================\n");

    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data saham: $e");
      print("❌ ERROR FETCH STOCK: $e");
    } finally {
      isLoading(false);
    }
  }
}