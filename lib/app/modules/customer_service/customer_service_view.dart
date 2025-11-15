import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'customer_service_controller.dart';

class CustomerServiceView extends GetView<CustomerServiceController> {
  const CustomerServiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Service")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.headset_mic_rounded, size: 100, color: Theme.of(context).primaryColor),
            SizedBox(height: 24),
            Text(
              "Butuh Bantuan?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Tim kami siap membantu Anda 24/7. Hubungi kami langsung melalui WhatsApp untuk respons yang lebih cepat.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: controller.launchWhatsApp,
              icon: Icon(Icons.chat_bubble_outline_rounded),
              label: Text("Chat via WhatsApp"),
            ),
          ],
        ),
      ),
    );
  }
}