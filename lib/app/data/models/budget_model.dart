class BudgetModel {
  final int id;
  final String categoryName;
  final double allocatedAmount;

  BudgetModel({
    required this.id,
    required this.categoryName,
    required this.allocatedAmount,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: _parseId(json['id']),
      categoryName: json['category_name'] ?? '',
      allocatedAmount: _parseAmount(json['allocated_amount']),
    );
  }

  static int _parseId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseAmount(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
