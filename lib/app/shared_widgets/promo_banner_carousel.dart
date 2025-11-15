import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetra/app/data/models/promo_banner_model.dart';
import 'package:monetra/app/utils/routes/app_routes.dart'; // <-- Pastikan ini di-import

class PromoBannerCarousel extends StatelessWidget {
  final List<PromoBannerModel> banners;
  const PromoBannerCarousel({Key? key, required this.banners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: banners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                if (banner.targetRoute.isNotEmpty) {
                  Get.toNamed(banner.targetRoute);
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                clipBehavior: Clip.antiAlias, // Tambahkan ini
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                // Ganti dari DecorationImage ke Image.network
                child: Image.network(
                  banner.imageUrl,
                  fit: BoxFit.cover,
                  // Tampilkan placeholder jika internet error
                  errorBuilder: (context, error, stackTrace) {
                    print("❌ ERROR Muat Gambar Banner: $error");
                    return Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey[600],
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}