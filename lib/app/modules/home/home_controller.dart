import 'package:get/get.dart';
import 'package:monetra/app/data/models/promo_banner_model.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';

class HomeController extends GetxController {
  final DataRepository _repository = DataRepository();

  final bannerList = <PromoBannerModel>[].obs;
  final isBannerLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  void fetchBanners() async {
    try {
      isBannerLoading(true);
      var banners = await _repository.getPromoBanners();
      bannerList.assignAll(banners);
    } finally {
      isBannerLoading(false);
    }
  }
}