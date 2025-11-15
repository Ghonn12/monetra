import 'package:get/get.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';
import 'tabungan_controller.dart';

class TabunganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DataRepository());
    Get.lazyPut(() => TabunganController());
  }
}