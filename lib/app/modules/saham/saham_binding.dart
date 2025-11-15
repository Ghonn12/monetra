import 'package:get/get.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';
import 'saham_controller.dart';

class SahamBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan Repository (jika belum ada) dan Controller
    Get.lazyPut(() => DataRepository());
    Get.lazyPut(() => SahamController());
  }
}