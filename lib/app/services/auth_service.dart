import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final _box = GetStorage();
  final _tokenKey = 'token';
  final _kycKey = 'status_kyc';
  // final _userKey = 'user'; // Nanti untuk simpan data user

  // Cek apakah token ada
  bool get isLoggedIn => getToken() != null;
  String? _token;

  String? get token => _token;

  void saveToken(String newToken) {
    _token = newToken;
  }
  // Panggil ini saat login berhasil
  Future<void> saveLoginData(Map<String, dynamic> data) async {
    final token = data['token'];
    final statusKyc = data['status_kyc'];

    await _box.write(_tokenKey, token);
    await _box.write(_kycKey, statusKyc);
  }

  // Update status KYC setelah upload
  Future<void> updateKycStatus(String status) async {
    await _box.write(_kycKey, status);
  }

  String? getToken() {
    return _box.read(_tokenKey);
  }

  String? getStatusKyc() {
    return _box.read(_kycKey);
  }

  // Panggil ini saat logout
  Future<void> logout() async {
    await _box.remove(_tokenKey);
    await _box.remove(_kycKey);
  }
}