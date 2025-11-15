class ApiConstants {
  // Ganti ini dengan alamat IP/domain server CI4 Anda
  //
  // Jika menggunakan Emulator Android:
  static const String baseUrl = "http://10.0.2.2:8081";
  //
  // Jika menggunakan Device Fisik (pastikan 1 jaringan):
  // static const String baseUrl = "http://192.168.1.5:8080";

  // Endpoints
  static const String login = "/api/login";
  static const String register = "/api/register";
  static const String kycUpload = "/api/kyc/upload";
  static const String getTabungan = "/api/tabungan";
  static const String getSahamAlphaVantage = "/api/stock/quote/"; // + {SIMBOL}
  static const String getSahamYahoo = "/api/yahoo/quote/"; // + {SIMBOL}
  static const String getCrypto = "/api/crypto/quote/"; // + {SIMBOL}
  static const String getSahamChart = "/api/yahoo/chart/";
  static const String getBudgets = "/api/budget";
  static const String createBudget = "/api/budget";
  // --- TAMBAHKAN INI ---
  static const String getTransaksi = "/api/transaksi";
}