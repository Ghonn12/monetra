import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:monetra/app/data/models/chart_model.dart';
import 'package:monetra/app/data/models/promo_banner_model.dart';
import 'package:monetra/app/data/models/saving_model.dart';
import 'package:monetra/app/data/models/stock_model.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/routes/app_routes.dart';
import '../models/crypto_model.dart';
import '../models/portofolio_model.dart';
import '../models/ticker_list_model.dart';
import '../models/transaksi_model.dart';
import 'package:monetra/app/data/models/budget_model.dart';
import 'package:monetra/app/data/models/transaksi_model.dart';

class RemoteProvider {
  // Gunakan 'getter' agar Dio baru diambil saat dibutuhkan
  Dio get _dio => Get.find<ApiService>().client;
  // -------------------------

  // --- AUTH ---
  Future<Response> login(String email, String password) async {
    final url = ApiConstants.login;
    print("\n==============================");
    print("🔵 LOGIN REQUEST");
    print("🔗 URL: ${_dio.options.baseUrl}$url");
    print("📩 BODY: email=$email, pass=$password");

    try {
      final response = await _dio.post(url,
          data: {'email': email, 'password': password});

      print("🟢 LOGIN RESPONSE: ${response.statusCode}");
      print("📄 DATA: ${response.data}");
      print("==============================\n");

      return response;
    } on DioException catch (e) {
      print("❌ LOGIN ERROR CAUGHT (Dio)");
      return e.response ?? _handleDioError(e);
    }
  }

  // --- TAMBAHKAN METHOD REGISTER DARI REPO ANDA KE SINI ---
  Future<Response> register(String name, String email, String password) async {
    final url = ApiConstants.register;
    print("\n==============================");
    print("🔵 REGISTER REQUEST");
    print("🔗 URL: ${_dio.options.baseUrl}$url");
    print("📩 BODY: name=$name, email=$email");

    try {
      final response = await _dio.post(url, data: {
        'nama': name,
        'email': email,
        'password': password,
      });

      print("🟢 REGISTER RESPONSE: ${response.statusCode}");
      print("📄 DATA: ${response.data}");
      print("==============================\n");

      return response;
    } on DioException catch (e) {
      print("❌ REGISTER ERROR CAUGHT (Dio)");
      return e.response ?? _handleDioError(e);
    }
  }
  // ---

  Future<Response> uploadKyc(File ktpFile, File selfieFile) async {
    final url = ApiConstants.kycUpload;
    print("\n==============================");
    print("🔵 KYC UPLOAD");
    print("🔗 URL: ${_dio.options.baseUrl}$url");

    try {
      final formData = FormData.fromMap({
        'ktp': await MultipartFile.fromFile(ktpFile.path, filename: 'ktp.jpg'),
        'selfie':
        await MultipartFile.fromFile(selfieFile.path, filename: 'selfie.jpg'),
      });

      final response = await _dio.post(url,
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));

      print("🟢 KYC RESPONSE: ${response.statusCode}");
      print("📄 DATA: ${response.data}");
      print("==============================\n");
      return response;
    } on DioException catch (e) {
      print("❌ KYC ERROR");
      return e.response ?? _handleDioError(e);
    }
  }

  // --- DATA SAHAM (INDONESIA) ---
  Future<StockModel> getIndoStock(String symbol) async {
    // Pastikan simbol memiliki .JK jika ini adalah saham Indo
    String ticker = symbol.endsWith('.JK') ? symbol : '$symbol.JK';
    final url = ApiConstants.getSahamYahoo + ticker;

    print("➡️ FETCH INDO STOCK: $ticker");
    print("🔗 URL: ${_dio.options.baseUrl}$url");

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        print("✅ SUCCESS INDO: $ticker");
        return StockModel.fromJsonYahoo(response.data);
      } else {
        throw Exception('Gagal memuat data saham Indo');
      }
    } catch (e) {
      print("❌ ERROR INDO STOCK ($ticker): ${e.toString()}");
      throw Exception('Error Indo Stock: ${e.toString()}');
    }
  }

  // --- DATA SAHAM (US/GLOBAL) ---
  Future<StockModel> getUsStock(String symbol) async {
    final url = ApiConstants.getSahamAlphaVantage + symbol;
    print("➡️ FETCH US STOCK: $symbol");
    print("🔗 URL: ${_dio.options.baseUrl}$url");
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        print("✅ SUCCESS US: $symbol");
        return StockModel.fromJsonAlphaVantage(response.data);
      } else {
        throw Exception('Gagal memuat data saham US');
      }
    } catch (e) {
      print("❌ ERROR US STOCK ($symbol): ${e.toString()}");
      throw Exception('Error US Stock: ${e.toString()}');
    }
  }

  // --- DATA CRYPTO ---
  Future<CryptoModel> getCryptoData(String symbol) async {
    final url = ApiConstants.getCrypto + symbol;
    print("\n==============================");
    print("🪙 GET CRYPTO DATA: $symbol");
    print("🔗 URL: ${_dio.options.baseUrl}$url");

    try {
      final response = await _dio.get(url);
      print("🟢 RESPONSE: ${response.statusCode}");
      if (response.statusCode == 200) {
        return CryptoModel.fromJson(response.data);
      }
      throw Exception('Gagal memuat data crypto');
    } catch (e) {
      print("❌ ERROR CRYPTO: $e");
      throw Exception('Error: $e');
    }
  }

  // --- DATA TABUNGAN (DARI API DATABASE) ---
  Future<List<SavingModel>> getSavings() async {
    final url = ApiConstants.getTabungan;
    print("\n==============================");
    print("🏦 GET TABUNGAN (DARI API)");
    print("🔗 URL: ${_dio.options.baseUrl}$url");

    try {
      final response = await _dio.get(url);
      print("🟢 RESPONSE: ${response.statusCode}");
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) => SavingModel.fromJson(item))
            .toList();
      }
      throw Exception('Gagal memuat data tabungan');
    } catch (e) {
      print("❌ ERROR TABUNGAN: $e");
      throw Exception('Error: $e');
    }
  }

  // --- DATA TICKER (MOCK 975) ---
  Future<List<TickerModel>> getMarketTickers() async {
    print("\n==============================");
    print("📈 GET MARKET TICKERS (Dummy 975)");
    print("🔗 This endpoint is NOT calling API");
    print("==============================\n");

    await Future.delayed(Duration(milliseconds: 1500));

    const int totalTickers = 975;
    final List<TickerModel> tickerList = [];
    final Random random = Random();

    final List<String> topTickers = [
      'BBCA', 'BBRI', 'TLKM', 'GOTO', 'ADRO', 'PGAS', 'UNVR', 'HMSP', 'ASII', 'ICBP'
    ];

    for (int i = 0; i < topTickers.length; i++) {
      tickerList.add(TickerModel(
        symbol: topTickers[i],
        name: _getTopTickerName(topTickers[i]),
      ));
    }

    for (int i = topTickers.length; i < totalTickers; i++) {
      final String randomSymbol =
      String.fromCharCodes(List.generate(4, (index) => random.nextInt(26) + 65));
      final String randomName = "Perusahaan Jasa ${i + 1} Tbk";
      tickerList.add(TickerModel(
        symbol: randomSymbol,
        name: randomName,
      ));
    }
    return tickerList.toSet().toList();
  }

  String _getTopTickerName(String symbol) {
    switch (symbol) {
      case 'BBCA': return 'Bank Central Asia Tbk';
      case 'BBRI': return 'Bank Rakyat Indonesia Tbk';
      case 'TLKM': return 'Telkom Indonesia (Persero) Tbk';
      case 'GOTO': return 'GoTo Gojek Tokopedia PT';
      case 'ADRO': return 'Adaro Energy Indonesia Tbk';
      case 'PGAS': return 'Perusahaan Gas Negara Tbk';
      case 'UNVR': return 'Unilever Indonesia Tbk';
      case 'HMSP': return 'HM Sampoerna Tbk';
      case 'ASII': return 'Astra International Tbk';
      case 'ICBP': return 'Indofood CBP Sukses Makmur Tbk';
      default: return 'Emiten Unggulan';
    }
  }

  // --- DATA PROMO (DUMMY) ---
  Future<List<PromoBannerModel>> getPromoBanners() async {
    print("\n==============================");
    print("🎌 GET PROMO BANNERS (Dummy)");
    print("🔗 This endpoint is NOT calling API");
    print("==============================\n");

    await Future.delayed(Duration(milliseconds: 500));
    return [
      PromoBannerModel(
        imageUrl: 'https://placehold.co/600x300/1A3E5C/FFFFFF/png?text=Promo+1',
        targetRoute: AppRoutes.SAHAM,
      ),
      PromoBannerModel(
        imageUrl: 'https://placehold.co/600x300/28A745/FFFFFF/png?text=Promo+2',
        targetRoute: AppRoutes.EXPLORE,
      ),
      PromoBannerModel(
        imageUrl: 'https://placehold.co/600x300/E63946/FFFFFF/png?text=Promo+3',
        targetRoute: AppRoutes.TABUNGAN,
      ),
    ];
  }

  // --- INI FUNGSI YANG BARU DIISI ---
  Future<ChartModel> getChartData(String symbol) async {
    // Backend CI4 Anda sudah menangani penambahan .JK
    final url = ApiConstants.getSahamChart + symbol;

    print("\n==============================");
    print("📊 GET CHART DATA: $symbol");
    print("🔗 URL: ${_dio.options.baseUrl}$url");

    try {
      final response = await _dio.get(url);

      print("🟢 RESPONSE: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("✅ SUCCESS CHART: $symbol");
        // Parsing JSON ke model
        return ChartModel.fromJson(response.data);
      } else {
        throw Exception('Gagal memuat data chart (Status: ${response.statusCode})');
      }
    } catch (e) {
      // Ini akan menangkap DioException dan Exception lainnya
      print("❌ ERROR CHART ($symbol): ${e.toString()}");
      print("==============================\n");
      throw Exception('Error Chart: ${e.toString()}');
    }
  }

  // Helper error
  Response _handleDioError(DioException e) {
    print("🔥 DioError Fallback Handler");
    print("🏷 TYPE: ${e.type}");
    print("📄 DATA: ${e.response?.data}");
    print("=====================================\n");

    return Response(
      requestOptions: e.requestOptions,
      statusCode: e.response?.statusCode ?? 500,
      statusMessage: e.response?.statusMessage ?? 'Server Error',
      data: e.response?.data ?? {'messages': {'error': 'Koneksi bermasalah'}},
    );
  }
  Future<List<TransaksiModel>> getTransaksiHistory() async {
    final url = ApiConstants.getTransaksi;
    print("\n==============================");
    print("🧾 GET RIWAYAT TRANSAKSI (DARI API)");
    print("🔗 URL: ${_dio.options.baseUrl}$url");

    try {
      final response = await _dio.get(url);
      print("🟢 RESPONSE: ${response.statusCode}");
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) => TransaksiModel.fromJson(item))
            .toList();
      }
      throw Exception('Gagal memuat data transaksi');
    } catch (e) {
      print("❌ ERROR TRANSAKSI: $e");
      throw Exception('Error: $e');
    }
  }
  Future<List<BudgetModel>> getBudgets() async {
    final url = ApiConstants.getBudgets;
    print("==============================");
    print("💰 GET BUDGETS (DARI API)");
    print("🔗 URL: ${_dio.options.baseUrl}$url");

    try {
      final response = await _dio.get(url);
      print("🟢 RESPONSE: ${response.statusCode}");
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) => BudgetModel.fromJson(item))
            .toList();
      }
      throw Exception('Gagal memuat data budget');
    } catch (e) {
      print("❌ ERROR BUDGETS: $e");
      throw Exception('Error: $e');
    }
  }
  Future<Response> createTransaksi({
    required String tipe,
    required double jumlah,
    required String keterangan,
    String? kodeAset,
  }) async {
    final url = "/api/transaksi";
    print("📤 POST TRANSAKSI: $tipe - $jumlah - $keterangan");

    try {
      final response = await _dio.post(url, data: {
        'tipe': tipe,
        'jumlah': jumlah,
        'keterangan': keterangan,
        'kode_aset': kodeAset,
      });
      print("🟢 RESPONSE: ${response.statusCode}");
      return response;
    } on DioException catch (e) {
      print("❌ ERROR TRANSAKSI: ${e.message}");
      return e.response ?? _handleDioError(e);
    }
  }

  // Membuat kategori budget baru
  Future<Response> createBudget(String name, double amount) async {
    final url = ApiConstants.createBudget;
    print("==============================");
    print("💰 CREATE BUDGET (DARI API)");
    print("🔗 URL: ${_dio.options.baseUrl}$url");
    print("📦 PAYLOAD: {category_name: $name, allocated_amount: $amount}");

    try {
      final response = await _dio.post(
        url,
        data: {
          'category_name': name,
          'allocated_amount': amount,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${Get.find<AuthService>().token}"
          },
        ),
      );

      print("🟢 RESPONSE: ${response.statusCode}");
      print("📨 RESPONSE BODY: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("❌ ERROR CREATE BUDGET: ${e.message}");
      if (e.response != null) {
        print("❌ SERVER RESPONSE: ${e.response?.data}");
        return e.response!;
      }
      return _handleDioError(e);
    } catch (e) {
      print("❌ UNEXPECTED ERROR: $e");
      rethrow;
    }
  }
  Future<List<CryptoModel>> getCryptoPortofolio() async {
    final response = await _dio.get("/api/crypto/portofolio");
    final List<dynamic> data = response.data;
    return data.map((json) => CryptoModel.fromJson(json)).toList();
  }
  Future<List<PortofolioModel>> getPortofolio() async {
    final response = await _dio.get("/api/portofolio");
    final List<dynamic> data = response.data;
    return data.map((json) => PortofolioModel.fromJson(json)).toList();
  }

}