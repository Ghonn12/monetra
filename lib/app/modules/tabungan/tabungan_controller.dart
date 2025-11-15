import 'package:get/get.dart';
import 'package:monetra/app/data/models/saving_model.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';

class TabunganController extends GetxController {
  final DataRepository _repository = Get.find<DataRepository>();

  final isLoading = false.obs;
  final savingList = <SavingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavings();
  }

  void fetchSavings() async {
    try {
      isLoading(true);
      var savings = await _repository.getSavings(); // Panggil API (dummy)
      savingList.assignAll(savings);
    } finally {
      isLoading(false);
    }
  }
}