import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'explore_controller.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Explore Crypto")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.cryptoList.length,
          itemBuilder: (context, index) {
            final crypto = controller.cryptoList[index];
            return ListTile(
              leading: CircleAvatar(child: Text(crypto.symbol.substring(0,1))),
              title: Text("${crypto.name} (${crypto.symbol})"),
              trailing: Text("\$${crypto.priceUsd.toStringAsFixed(2)}"),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.fetchCryptoData(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}