// import 'package:sqflite/sqflite.dart'; // Contoh jika nanti pakai SQLite

class LocalProvider {
  // --- SAAT INI KOSONG ---
  // Semua logika data kita (termasuk mock) saat ini ditangani oleh
  // RemoteProvider untuk kesederhanaan.

  // --- CONTOH JIKA MENGGUNAKAN SQLITE NANTI ---
  /*
  Future<Database> get database async {
    // Logika untuk membuka atau membuat database SQLite
  }

  Future<List<Map<String, dynamic>>> getOfflineTransactions() async {
    final db = await database;
    return await db.query('transactions');
  }
  */
}