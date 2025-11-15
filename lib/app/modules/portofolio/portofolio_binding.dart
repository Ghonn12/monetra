import 'package:get/get.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';
import 'portofolio_controller.dart';

class PortofolioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DataRepository());
    Get.lazyPut(() => PortofolioController());
  }
}