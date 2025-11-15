import 'package:dio/dio.dart'; // gunakan Response dari Dio
import 'package:monetra/app/data/models/chart_model.dart';
import 'package:monetra/app/data/models/crypto_model.dart';
import 'package:monetra/app/data/models/promo_banner_model.dart';
import 'package:monetra/app/data/models/saving_model.dart';
import 'package:monetra/app/data/models/stock_model.dart';
import 'package:monetra/app/data/providers/remote_provider.dart';
import '../models/portofolio_model.dart';
import '../models/ticker_list_model.dart';
import '../models/transaksi_model.dart';
import 'package:monetra/app/data/models/budget_model.dart';

class DataRepository {
  final RemoteProvider _provider = RemoteProvider();

  Future<List<PromoBannerModel>> getPromoBanners() {
    return _provider.getPromoBanners();
  }

  Future<List<SavingModel>> getSavings() {
    return _provider.getSavings();
  }

  Future<StockModel> getIndoStock(String symbol) {
    return _provider.getIndoStock(symbol);
  }

  Future<StockModel> getUsStock(String symbol) {
    return _provider.getUsStock(symbol);
  }

  Future<CryptoModel> getCryptoData(String symbol) {
    return _provider.getCryptoData(symbol);
  }

  Future<List<TickerModel>> getMarketTickers() {
    return _provider.getMarketTickers();
  }

  Future<ChartModel> getChartData(String symbol) {
    return _provider.getChartData(symbol);
  }

  Future<List<TransaksiModel>> getTransaksiHistory() {
    return _provider.getTransaksiHistory();
  }

  Future<List<BudgetModel>> getBudgets() {
    return _provider.getBudgets();
  }

  Future<Response> createBudget(String name, double amount) {
    return _provider.createBudget(name, amount);
  }

  Future<Response> createTransaksi({
    required String tipe,
    required double jumlah,
    required String keterangan,
    String? kodeAset,
  }) {
    return _provider.createTransaksi(
      tipe: tipe,
      jumlah: jumlah,
      keterangan: keterangan,
      kodeAset: kodeAset,
    );
  }

  // ✅ gunakan method dari RemoteProvider, bukan .get langsung
  Future<List<CryptoModel>> getCryptoPortofolio() {
    return _provider.getCryptoPortofolio();
  }
  Future<List<PortofolioModel>> getPortofolio() {
    return _provider.getPortofolio();
  }


}
