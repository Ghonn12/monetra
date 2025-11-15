class AppRoutes {
  static const SPLASH = '/splash';

  // Auth
  static const AUTH_LOGIN = '/login';
  static const AUTH_REGISTER = '/register';
  static const AUTH_KYC = '/kyc';

  // Dashboard (BottomNav)
  static const DASHBOARD = '/'; // Root
  static const HOME = '/home';

  // Fitur Utama (dari Tab)
  static const TABUNGAN = '/tabungan';
  static const SAHAM = '/saham';
  static const PORTOFOLIO = '/portofolio';
  static const TRANSAKSI = '/transaksi';

  static const SAHAM_DETAIL = '/saham-detail/:symbol';

  // Fitur Tambahan (dari Home)
  static const EXPLORE = '/explore';
  static const HISTORY = '/history';
  static const AKUN = '/akun';

  // --- TAMBAHKAN RUTE BARU ---
  static const CUSTOMER_SERVICE = '/customer-service';
  static const AUTO_BUDGET = '/auto-budget';
}