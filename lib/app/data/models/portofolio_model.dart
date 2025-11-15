class PortofolioModel {
  final int id;
  final int userId;
  final String stockSymbol;
  final int jumlahLembar;
  final double hargaBeliRataRata;
  final DateTime createdAt;
  final DateTime updatedAt;

  PortofolioModel({
    required this.id,
    required this.userId,
    required this.stockSymbol,
    required this.jumlahLembar,
    required this.hargaBeliRataRata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PortofolioModel.fromJson(Map<String, dynamic> json) {
    return PortofolioModel(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      stockSymbol: json['stock_symbol'],
      jumlahLembar: int.parse(json['jumlah_lembar'].toString()),
      hargaBeliRataRata: (json['harga_beli_rata_rata'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'stock_symbol': stockSymbol,
      'jumlah_lembar': jumlahLembar,
      'harga_beli_rata_rata': hargaBeliRataRata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Helper untuk hitung total nilai portofolio saham ini
  double get totalValue => jumlahLembar * hargaBeliRataRata;
}
