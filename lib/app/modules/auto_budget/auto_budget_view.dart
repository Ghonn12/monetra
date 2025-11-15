import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';
import 'auto_budget_controller.dart';

class AutoBudgetView extends GetView<AutoBudgetController> {
  const AutoBudgetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Auto Budgeting")),
      body: Obx(() {
        if (controller.isLoading.value && controller.budgetList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchData(),
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              // --- KARTU RINGKASAN ---
              _buildSummaryCard(),
              SizedBox(height: 24),

              Text(
                "Rincian Kategori",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // --- DAFTAR KATEGORI ---
              if (controller.budgetList.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      "Anda belum punya kategori budget. Tekan tombol + untuk menambah.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),

              ...controller.budgetList.map((budget) {
                return _buildBudgetCategoryCard(budget);
              }).toList(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.showAddBudgetDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  // Widget untuk kartu ringkasan
  Widget _buildSummaryCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ringkasan Budget Bulan Ini", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary)),
            SizedBox(height: 16),
            _buildSummaryRow("Total Anggaran:", "Rp ${controller.totalAllocated.value.toStringAsFixed(0)}", Colors.black),
            SizedBox(height: 8),
            _buildSummaryRow("Total Pengeluaran:", "Rp ${controller.totalSpent.value.toStringAsFixed(0)}", AppTheme.error),
            Divider(height: 24),
            _buildSummaryRow(
              "Sisa Anggaran:",
              "Rp ${controller.totalRemaining.toStringAsFixed(0)}",
              AppTheme.secondary,
              isBold: true,
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
        Text(
          amount,
          style: TextStyle(
            fontSize: isBold ? 17 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }

  // Widget untuk setiap kategori budget
  Widget _buildBudgetCategoryCard(BudgetDisplayModel budget) {
    final color = budget.isOverBudget ? AppTheme.error : AppTheme.secondary;

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              budget.category.categoryName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rp ${budget.spentAmount.toStringAsFixed(0)}",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "/ Rp ${budget.category.allocatedAmount.toStringAsFixed(0)}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: budget.progress,
                minHeight: 12,
                backgroundColor: Colors.grey[300],
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}