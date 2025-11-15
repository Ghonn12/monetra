import 'package:get/get.dart';
import 'package:monetra/app/modules/akun/akun_binding.dart';
import 'package:monetra/app/modules/akun/akun_view.dart';
import 'package:monetra/app/modules/auth/auth_binding.dart';
import 'package:monetra/app/modules/auth/auth_view.dart';
import 'package:monetra/app/modules/dashboard/dashboard_binding.dart';
import 'package:monetra/app/modules/dashboard/dashboard_view.dart';
import 'package:monetra/app/modules/explore/explore_binding.dart';
import 'package:monetra/app/modules/explore/explore_view.dart';
import 'package:monetra/app/modules/home/home_binding.dart';
import 'package:monetra/app/modules/home/home_view.dart';
import 'package:monetra/app/modules/portofolio/portofolio_binding.dart';
import 'package:monetra/app/modules/portofolio/portofolio_view.dart';
import 'package:monetra/app/modules/saham/saham_binding.dart';
import 'package:monetra/app/modules/saham/saham_view.dart';
import 'package:monetra/app/modules/splash/splash_binding.dart';
import 'package:monetra/app/modules/splash/splash_view.dart';
import 'package:monetra/app/modules/tabungan/tabungan_binding.dart';
import 'package:monetra/app/modules/tabungan/tabungan_view.dart';
import 'package:monetra/app/modules/transaksi/transaksi_binding.dart';
import 'package:monetra/app/modules/transaksi/transaksi_view.dart';
import 'package:monetra/app/modules/stock_detail/stock_detail_binding.dart';
import 'package:monetra/app/modules/stock_detail/stock_detail_view.dart';
import 'app_routes.dart';
import 'package:monetra/app/modules/auto_budget/auto_budget_binding.dart';
import 'package:monetra/app/modules/auto_budget/auto_budget_view.dart';
import 'package:monetra/app/modules/customer_service/customer_service_binding.dart';
import 'package:monetra/app/modules/customer_service/customer_service_view.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    // Auth
    GetPage(
      name: AppRoutes.AUTH_LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.AUTH_KYC,
      page: () => const KycView(),
      binding: AuthBinding(), // Pakai AuthBinding yang sama
    ),

    // Dashboard (Host BottomNav)
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardView(),
      // Bind semua controller tab di sini
      bindings: [
        DashboardBinding(),
        HomeBinding(),
        TabunganBinding(),
        SahamBinding(),
        TransaksiBinding(),
        PortofolioBinding(),
      ],
    ),

    // Rute Halaman Penuh (di luar Tab)
    GetPage(
      name: AppRoutes.EXPLORE,
      page: () => const ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: AppRoutes.AKUN,
      page: () => const AkunView(),
      binding: AkunBinding(),
    ),
    GetPage(
      name: AppRoutes.AUTH_REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.SAHAM_DETAIL,
      page: () => const StockDetailView(),
      binding: StockDetailBinding(),
      transition: Transition.rightToLeft, // Animasi transisi
    ),
    GetPage(
      name: AppRoutes.CUSTOMER_SERVICE,
      page: () => const CustomerServiceView(),
      binding: CustomerServiceBinding(),
    ),
    GetPage(
      name: AppRoutes.AUTO_BUDGET,
      page: () => const AutoBudgetView(),
      binding: AutoBudgetBinding(),
    ),
    // ... (Halaman lain seperti History)
  ];
}