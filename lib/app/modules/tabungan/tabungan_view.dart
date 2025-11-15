import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';
import 'tabungan_controller.dart';

class TabunganView extends GetView<TabunganController> {
  const TabunganView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tujuan Tabungan")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.savingList.length,
          itemBuilder: (context, index) {
            final saving = controller.savingList[index];
            double progress = (saving.currentAmount / saving.targetAmount).clamp(0.0, 1.0);

            return Card(
              elevation: 2,
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(saving.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rp ${saving.currentAmount.toStringAsFixed(0)}", style: TextStyle(color: AppTheme.secondary, fontWeight: FontWeight.bold)),
                        Text("Target: Rp ${saving.targetAmount.toStringAsFixed(0)}", style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.grey[300],
                        color: AppTheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}