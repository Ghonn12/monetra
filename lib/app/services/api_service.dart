import 'package:dio/dio.dart' as dio_pkg;
import 'package:get/get.dart';

import '../utils/constants/api_constants.dart';
import 'auth_service.dart';
import 'package:monetra/app/utils/routes/app_routes.dart';

class ApiService extends GetxService {
  late dio_pkg.Dio dio;

  @override
  void onInit() {
    dio = dio_pkg.Dio(
      dio_pkg.BaseOptions(
        baseUrl: ApiConstants.baseUrl, // http://10.0.2.2:8081
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      dio_pkg.InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = Get.find<AuthService>().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (options.method == 'POST' &&
              options.headers['Content-Type'] == null &&
              options.data is! dio_pkg.FormData) {
            options.headers['Content-Type'] = 'application/json';
          }
          return handler.next(options);
        },
        onError: (e, handler) {
          if (e.response?.statusCode == 401) {
            Get.find<AuthService>().logout();
            Get.offAllNamed(AppRoutes.AUTH_LOGIN);
          }
          return handler.next(e);
        },
      ),
    );

    print("🛠️ ApiService initialized with baseUrl = ${dio.options.baseUrl}");
    super.onInit();
  }

  dio_pkg.Dio get client => dio;
}

