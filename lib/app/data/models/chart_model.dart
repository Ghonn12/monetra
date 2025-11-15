class ChartModel {
  final String symbol;
  final String currency;
  final String exchangeName;
  final double? regularMarketPrice;
  final double? previousClose;
  final List<int> chartTimestamp;
  final List<double?> chartClose; // Bisa jadi ada data null

  ChartModel({
    required this.symbol,
    required this.currency,
    required this.exchangeName,
    this.regularMarketPrice,
    this.previousClose,
    required this.chartTimestamp,
    required this.chartClose,
  });

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    // Konversi List<dynamic> ke tipe yang benar
    var timestamps = (json['chartTimestamp'] as List<dynamic>? ?? [])
        .map((e) => e as int)
        .toList();

    var closes = (json['chartClose'] as List<dynamic>? ?? [])
        .map((e) => (e as num?)?.toDouble()) // Konversi num? ke double?
        .toList();

    return ChartModel(
      symbol: json['symbol'] ?? 'N/A',
      currency: json['currency'] ?? 'N/A',
      exchangeName: json['exchangeName'] ?? 'N/A',
      regularMarketPrice: (json['regularMarketPrice'] as num?)?.toDouble(),
      previousClose: (json['previousClose'] as num?)?.toDouble(),
      chartTimestamp: timestamps,
      chartClose: closes,
    );
  }
}