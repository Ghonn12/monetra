import 'package:get/get.dart';
import 'customer_service_controller.dart';

class CustomerServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerServiceController());
  }
}