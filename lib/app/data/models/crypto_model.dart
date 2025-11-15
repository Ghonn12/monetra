class CryptoModel {
  final String symbol;
  final String name;
  final double priceUsd;

  CryptoModel({
    required this.symbol,
    required this.name,
    required this.priceUsd,
  });

  // Factory untuk parsing JSON dari API Alpha Vantage
  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      symbol: json['symbol'] ?? 'N/A',
      name: json['name'] ?? 'Unknown',
      priceUsd: (json['price_usd'] ?? 0.0).toDouble(),
    );
  }
}