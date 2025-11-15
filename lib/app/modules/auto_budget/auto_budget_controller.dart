import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/data/models/budget_model.dart';
import 'package:monetra/app/data/models/transaksi_model.dart';
import 'package:monetra/app/data/repositories/data_repository.dart';
import 'package:monetra/app/modules/transaksi/transaksi_controller.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';

// Model lokal untuk menggabungkan data budget + transaksi
class BudgetDisplayModel {
  final BudgetModel category;
  final double spentAmount;
  double get progress => (spentAmount / category.allocatedAmount).clamp(0.0, 1.0);
  double get remainingAmount => category.allocatedAmount - spentAmount;
  bool get isOverBudget => spentAmount > category.allocatedAmount;

  BudgetDisplayModel({required this.category, required this.spentAmount});
}

class AutoBudgetController extends GetxController {
  // Dependencies
  final DataRepository _repository = Get.find<DataRepository>();
  final TransaksiController _transaksiController = Get.find<TransaksiController>();

  // Controllers untuk dialog
  final categoryNameController = TextEditingController();
  final allocatedAmountController = TextEditingController();

  // States
  final isLoading = false.obs;
  final budgetList = <BudgetDisplayModel>[].obs;
  final totalAllocated = 0.0.obs;
  final totalSpent = 0.0.obs;
  double get totalRemaining => totalAllocated.value - totalSpent.value;

  @override
  void onInit() {
    super.onInit();
    // Panggil fetchData saat halaman dibuka
    fetchData();
  }

  @override
  void onClose() {
    categoryNameController.dispose();
    allocatedAmountController.dispose();
    super.onClose();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);

      // 1. Ambil alokasi budget dari API
      final List<BudgetModel> categories = await _repository.getBudgets();

      // 2. Pastikan data transaksi sudah ter-fetch (jika belum)
      if (_transaksiController.transaksiList.isEmpty) {
        await _transaksiController.fetchTransaksi();
      }
      final List<TransaksiModel> transactions = _transaksiController.transaksiList;

      // 3. Proses & Kalkulasi
      double tempTotalAllocated = 0.0;
      double tempTotalSpent = 0.0;
      List<BudgetDisplayModel> displayList = [];

      for (var category in categories) {
        // Hitung total pengeluaran untuk kategori ini
        double spent = _calculateSpentForCategory(category.categoryName, transactions);

        displayList.add(BudgetDisplayModel(
          category: category,
          spentAmount: spent,
        ));

        tempTotalAllocated += category.allocatedAmount;
        tempTotalSpent += spent;
      }

      // Update state
      budgetList.assignAll(displayList);
      totalAllocated.value = tempTotalAllocated;
      totalSpent.value = tempTotalSpent;

    } catch (e) {
      _showError("Gagal memuat data budget: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // Logika pencocokan sederhana:
  // Jika nama kategori "Makan", cari transaksi dg keterangan "makan"
  double _calculateSpentForCategory(String categoryName, List<TransaksiModel> transactions) {
    double total = 0.0;
    String categoryLower = categoryName.toLowerCase();

    for (var trx in transactions) {
      // Hanya hitung pengeluaran
      if (trx.tipe != 'DEPOSIT' && trx.tipe != 'SELL_STOCK') {
        if (trx.keterangan.toLowerCase().contains(categoryLower)) {
          total += trx.jumlah;
        }
      }
    }
    return total;
  }

  // Tampilkan dialog untuk menambah kategori
  void showAddBudgetDialog() {
    categoryNameController.clear();
    allocatedAmountController.clear();

    Get.defaultDialog(
      title: "Kategori Budget Baru",
      content: Column(
        children: [
          TextField(
            controller: categoryNameController,
            decoration: InputDecoration(labelText: "Nama Kategori (cth: Makan)"),
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(height: 16),
          TextField(
            controller: allocatedAmountController,
            decoration: InputDecoration(labelText: "Jumlah Anggaran (cth: 500000)"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      textCancel: "Batal",
      textConfirm: "Simpan",
      confirmTextColor: Colors.white,
      onConfirm: () {
        submitNewBudget();
        Get.back(); // Tutup dialog
      },
    );
  }

  // Kirim kategori baru ke API
  void submitNewBudget() async {
    final String name = categoryNameController.text.trim();
    final double? amount = double.tryParse(allocatedAmountController.text);

    if (name.isEmpty || amount == null || amount <= 0) {
      _showError("Nama kategori dan jumlah anggaran harus diisi dengan benar.");
      return;
    }

    isLoading(true); // Tampilkan loading utama
    try {
      final response = await _repository.createBudget(name, amount);
      if (response.statusCode == 201) {
        Get.snackbar("Sukses", "Kategori '$name' berhasil ditambahkan.",
            backgroundColor: AppTheme.secondary, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
        await fetchData(); // Muat ulang semua data
      } else {
        _showError(response.data['messages']?.toString() ?? "Gagal menyimpan");
      }
    } catch (e) {
      _showError("Gagal terhubung ke server.");
    } finally {
      isLoading(false);
    }
  }

  void _showError(String message) {
    Get.snackbar("Error", message,
        backgroundColor: AppTheme.error, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }
}