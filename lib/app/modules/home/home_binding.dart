import 'package:get/get.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DataRepository());
    Get.lazyPut(() => HomeController());
  }
}