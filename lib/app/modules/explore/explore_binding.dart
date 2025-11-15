import 'package:get/get.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';
import 'explore_controller.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DataRepository());
    Get.lazyPut(() => ExploreController());
  }
}