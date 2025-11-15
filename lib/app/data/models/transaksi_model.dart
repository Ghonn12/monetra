import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // untuk format tanggal

class TransaksiModel {
  final int id;
  final int userId;
  final String tipe;
  final String status;
  final double jumlah;
  final String keterangan;
  final String kodeAset;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Getter date untuk format rapi
  String get date => DateFormat("dd MMM yyyy, HH:mm").format(createdAt);

  TransaksiModel({
    required this.id,
    required this.userId,
    required this.tipe,
    required this.status,
    required this.jumlah,
    required this.keterangan,
    required this.kodeAset,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      tipe: json['tipe'],
      status: json['status'],
      jumlah: double.parse(json['jumlah'].toString()),
      keterangan: json['keterangan'],
      kodeAset: json['kode_aset'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Getter untuk format tanggal
  String get tanggal {
    return DateFormat("dd MMM yyyy, HH:mm").format(createdAt);
  }

  // Helper untuk Ikon
  IconData get icon {
    switch (tipe) {
      case 'DEPOSIT':
        return Icons.account_balance_wallet_outlined;
      case 'BUY_STOCK':
        return Icons.show_chart;
      case 'SELL_STOCK':
        return Icons.stacked_line_chart_outlined;
      case 'TOPUP_TABUNGAN':
        return Icons.savings_outlined;
      case 'WITHDRAW':
        return Icons.money_off_csred_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  // Helper untuk Warna
  Color get color {
    switch (tipe) {
      case 'DEPOSIT':
      case 'SELL_STOCK':
        return Colors.green; // Uang Masuk
      case 'BUY_STOCK':
      case 'TOPUP_TABUNGAN':
      case 'WITHDRAW':
        return Colors.red; // Uang Keluar
      default:
        return Colors.grey;
    }
  }
}
