class StockModel {
  final String symbol;
  final String longName;
  final double price;
  final double changePercent;

  StockModel({
    required this.symbol,
    required this.longName,
    required this.price,
    required this.changePercent,
  });

  // Factory 1: Untuk data Saham Indonesia (dari Yahoo Finance Gateway)
  factory StockModel.fromJsonYahoo(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['symbol'] ?? 'N/A',
      longName: json['longName'] ?? json['shortName'] ?? 'Unknown',
      price: (json['price'] ?? 0.0).toDouble(),
      changePercent: (json['change_percent'] ?? 0.0).toDouble(),
    );
  }

  // Factory 2: Untuk data Saham US (dari Alpha Vantage Gateway)
  factory StockModel.fromJsonAlphaVantage(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['symbol'] ?? 'N/A',
      longName: json['symbol'] ?? 'Unknown', // AV tidak menyediakan nama
      price: (json['price'] ?? 0.0).toDouble(),
      changePercent: (json['change_percent'] ?? 0.0).toDouble(),
    );
  }
}