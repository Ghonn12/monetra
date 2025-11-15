import 'package:get/get.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';
import 'package:monetra/app/modules/transaksi/transaksi_controller.dart';
import 'auto_budget_controller.dart';

class AutoBudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DataRepository());
    Get.lazyPut(() => TransaksiController()); // <-- Perlu ini untuk data pengeluaran
    Get.lazyPut(() => AutoBudgetController());
  }
}