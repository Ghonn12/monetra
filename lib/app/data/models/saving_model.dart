class SavingModel {
  final String id;
  final String name;
  final double currentAmount;
  final double targetAmount;

  SavingModel({
    required this.id,
    required this.name,
    required this.currentAmount,
    required this.targetAmount,
  });

  factory SavingModel.fromJson(Map<String, dynamic> json) {
    return SavingModel(
      id: json['id'].toString(),
      name: json['nama_tabungan'] ?? 'Tabungan',
      currentAmount: double.tryParse(json['jumlah_sekarang'].toString()) ?? 0.0,
      targetAmount: double.tryParse(json['target_jumlah'].toString()) ?? 0.0,
    );
  }
}