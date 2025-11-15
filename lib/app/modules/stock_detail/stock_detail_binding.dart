import 'package:get/get.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';
import 'stock_detail_controller.dart';

class StockDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Kita butuh DataRepository untuk mengambil data chart
    Get.lazyPut(() => DataRepository());

    Get.lazyPut(() => StockDetailController());
  }
}