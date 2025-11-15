import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:monetra/app/services/api_service.dart';
import 'package:monetra/app/services/auth_service.dart';
import 'package:monetra/app/services/settings_service.dart';
import 'package:monetra/app/utils/routes/app_pages.dart';
import 'package:monetra/app/utils/theme/app_theme.dart';

import 'app/data/providers/remote_provider.dart';
import 'app/data/repositories/auth_repository.dart';
import 'app/data/repositories/data_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await initServices();  // <-- WAJIB panggil ini!

  runApp(MonetraApp());
}

// Fungsi untuk mendaftarkan semua service global (singleton)
Future<void> initServices() async {
  print("🔧 Starting services...");

  Get.put(SettingsService(), permanent: true);
  Get.put(AuthService(), permanent: true);

  // ApiService duluan
  await Get.putAsync<ApiService>(() async => ApiService(), permanent: true);

  // Baru RemoteProvider
  Get.put(RemoteProvider(), permanent: true);

  Get.put(AuthRepository(), permanent: true);
  Get.put(DataRepository(), permanent: true);

  print("✅ All services started");
}



class MonetraApp extends StatelessWidget {
  // Ambil service tema
  final SettingsService settingsService = Get.find<SettingsService>();

  MonetraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Monetra",
      debugShowCheckedModeBanner: false,

      // Tema dari AppTheme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Ambil mode tema dari SettingsService
      themeMode: settingsService.getThemeMode(),

      // Routing GetX
      initialRoute: AppPages.INITIAL, // Rute awal (SPLASH)
      getPages: AppPages.routes, // Daftar semua rute
    );
  }
}

