import 'dart:io';
import 'package:dio/dio.dart'; // <-- Dibutuhkan untuk tipe 'Response'
import 'package:get/get.dart' hide Response; // <-- Hapus 'hide Response'
import '../providers/remote_provider.dart';

class AuthRepository {
  // 1. Repository HANYA tahu tentang Provider
  final RemoteProvider _provider = RemoteProvider();

  // 2. Tidak perlu 'dio' atau constructor yang rumit di sini

  Future<Response> login(String email, String password) {
    // Hanya meneruskan panggilan
    return _provider.login(email, password);
  }

  // --- FUNGSI REGISTER (DIPERBAIKI) ---
  Future<Response> register(String name, String email, String password) {
    // Teruskan panggilannya ke provider, sama seperti login
    return _provider.register(name, email, password);
  }
  // ---

  Future<Response> uploadKyc(File ktpFile, File selfieFile) {
    // Hanya meneruskan panggilan
    return _provider.uploadKyc(ktpFile, selfieFile);
  }
}