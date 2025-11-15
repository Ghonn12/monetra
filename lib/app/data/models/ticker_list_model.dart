class TickerModel {
  final String symbol;
  final String name; // Nama Perusahaan (opsional, untuk tampilan list)

  TickerModel({required this.symbol, required this.name});

  factory TickerModel.fromJson(Map<String, dynamic> json) {
    return TickerModel(
      symbol: json['symbol'] ?? 'N/A',
      name: json['name'] ?? 'N/A',
    );
  }
}