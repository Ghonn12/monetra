// lib/app/data/models/user_model.dart

class UserModel {
  final int id;
  final String nama;
  final String email;
  final String statusKyc;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.statusKyc,
  });

  // Konversi dari JSON (Map) ke UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Sesuaikan key ini dengan payload 'data' di JWT Anda
      id: json['user_id'],
      nama: json['nama'],
      email: json['email'],
      statusKyc: json['status_kyc'],
    );
  }

  // Konversi dari UserModel ke JSON (Map) (untuk disimpan di GetStorage)
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'nama': nama,
      'email': email,
      'status_kyc': statusKyc,
    };
  }
}