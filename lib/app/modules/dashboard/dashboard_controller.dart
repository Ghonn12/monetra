import 'package:get/get.dart';

class DashboardController extends GetxController {
  // 4 adalah index untuk tab 'Home'
  final tabIndex = 4.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}