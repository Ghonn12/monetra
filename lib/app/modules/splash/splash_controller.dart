import 'package:get/get.dart';
import '../../utils/routes/app_routes.dart'; // Import rute Anda
import '../../services/auth_service.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  @override
  void onInit() {
    super.onInit();
    _startApp();
  }

  void _startApp() async {
    // Tunggu 4 detik
    await Future.delayed(Duration(milliseconds: 9500));

    // (NANTI KITA UBAH LOGIKA INI)
    // Logika sementara: Setelah 4 detik, lempar ke Halaman Login
    Get.offAllNamed(AppRoutes.AUTH_LOGIN);

    if (_authService.isLoggedIn) {
      // Jika login, cek status KYC
      String? statusKyc = _authService.getStatusKyc();

      if (statusKyc == "NOT_VERIFIED") {
        // Jika belum KYC, lempar ke halaman KYC
        Get.offAllNamed(AppRoutes.AUTH_KYC);
      } else {
        // Jika sudah (VERIFIED, PENDING, REJECTED), lempar ke Dashboard
        Get.offAllNamed(AppRoutes.DASHBOARD);
      }
    } else {
      // Jika tidak ada token, lempar ke Halaman Login
      Get.offAllNamed(AppRoutes.AUTH_LOGIN);
    }
  }
}