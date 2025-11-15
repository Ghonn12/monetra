<?php

namespace App\Controllers\Api;

use App\Models\TransaksiModel;
use CodeIgniter\API\ResponseTrait;
use CodeIgniter\Controller;

class Transaksi extends Controller
{
    use ResponseTrait;

    /**
     * Endpoint: GET /api/transaksi
     * Mengambil riwayat transaksi user yang login
     * (Wajib terautentikasi)
     */
    public function index()
    {
        $model = new TransaksiModel();

        // 1. Ambil ID user dari token (disuntik oleh JwtAuthFilter)
        $userId = $this->request->user->user_id;

        // 2. Cari semua transaksi HANYA untuk user tersebut
        // (Kita urutkan dari yang terbaru)
        $data = $model->where('user_id', $userId)
            ->orderBy('created_at', 'DESC')
            ->findAll();

        // 3. Kembalikan data
        return $this->respond($data);
    }
    public function create()
    {
        $data = $this->request->getPost();

        if (empty($data['tipe']) || empty($data['jumlah']) || empty($data['keterangan'])) {
            return $this->failValidationErrors('Field tipe, jumlah, dan keterangan wajib diisi.');
        }

        $userId = $this->request->user->user_id ?? 1;
        $transaksiModel = new TransaksiModel();

        try {
            // 1. Simpan transaksi
            $transaksiModel->save([
                'user_id' => $userId,
                'tipe' => $data['tipe'],
                'status' => 'SUCCESS',
                'jumlah' => $data['jumlah'],
                'keterangan' => $data['keterangan'],
                'kode_aset' => $data['kode_aset'] ?? null,
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),
            ]);

            // 2. Update portofolio sesuai tipe transaksi
            if (!empty($data['kode_aset'])) {
                $portofolioModel = new PortofolioSahamModel();
                $existing = $portofolioModel
                    ->where('user_id', $userId)
                    ->where('stock_symbol', $data['kode_aset'])
                    ->first();

                $jumlahLembar = $data['jumlah_lembar'] ?? 0;
                $hargaBeli = $data['harga_beli'] ?? 0;

                if ($data['tipe'] === 'BUY_STOCK') {
                    if ($existing) {
                        // Hitung average harga baru
                        $totalLembar = $existing['jumlah_lembar'] + $jumlahLembar;
                        $totalInvestasi = ($existing['jumlah_lembar'] * $existing['harga_beli_rata_rata'])
                            + ($jumlahLembar * $hargaBeli);

                        $avgHargaBaru = $totalInvestasi / $totalLembar;

                        $portofolioModel->update($existing['id'], [
                            'jumlah_lembar' => $totalLembar,
                            'harga_beli_rata_rata' => $avgHargaBaru,
                            'updated_at' => date('Y-m-d H:i:s'),
                        ]);
                    } else {
                        $portofolioModel->insert([
                            'user_id' => $userId,
                            'stock_symbol' => $data['kode_aset'],
                            'jumlah_lembar' => $jumlahLembar,
                            'harga_beli_rata_rata' => $hargaBeli,
                            'created_at' => date('Y-m-d H:i:s'),
                            'updated_at' => date('Y-m-d H:i:s'),
                        ]);
                    }
                } elseif ($data['tipe'] === 'SELL_STOCK' && $existing) {
                    // Kurangi jumlah lembar
                    $sisaLembar = $existing['jumlah_lembar'] - $jumlahLembar;

                    if ($sisaLembar > 0) {
                        $portofolioModel->update($existing['id'], [
                            'jumlah_lembar' => $sisaLembar,
                            'updated_at' => date('Y-m-d H:i:s'),
                        ]);
                    } else {
                        // Jika semua lembar dijual, hapus portofolio
                        $portofolioModel->delete($existing['id']);
                    }
                }
            }

            return $this->respondCreated(['message' => 'Transaksi & portofolio berhasil disimpan']);
        } catch (\Throwable $e) {
            return $this->failServerError('Gagal menyimpan transaksi: ' . $e->getMessage());
        }
    }
}