import 'package:get/get.dart';
import 'transaksi_controller.dart';

class TransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransaksiController());
  }
}