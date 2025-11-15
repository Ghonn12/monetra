<?php

namespace App\Controllers\Api;

use App\Models\PortofolioSahamModel;
use CodeIgniter\API\ResponseTrait;
use CodeIgniter\RESTful\ResourceController;

class PortofolioSaham extends ResourceController
{
    use ResponseTrait;

    /**
     * Endpoint: GET /api/portofolio
     * Ambil semua portofolio saham milik user
     */
    public function index()
    {
        $model = new PortofolioSahamModel();
        $userId = $this->request->user->user_id;

        $data = $model->where('user_id', $userId)->findAll();

        return $this->respond($data);
    }

    /**
     * Endpoint: POST /api/portofolio
     * Tambah atau update portofolio saham (BUY/SELL)
     */
    public function create()
    {
        $data = $this->request->getJSON(true);

        if (empty($data['stock_symbol']) || empty($data['jumlah_lembar']) || empty($data['tipe'])) {
            return $this->failValidationErrors('Field stock_symbol, jumlah_lembar, dan tipe wajib diisi.');
        }

        $userId = $this->request->user->user_id ?? 1;
        $model = new PortofolioSahamModel();

        $existing = $model->where('user_id', $userId)
                          ->where('stock_symbol', $data['stock_symbol'])
                          ->first();

        $jumlahLembar = (int) $data['jumlah_lembar'];
        $hargaBeli    = (float) ($data['harga_beli'] ?? 0);

        if ($data['tipe'] === 'BUY_STOCK') {
            if ($existing) {
                $totalLembar = $existing['jumlah_lembar'] + $jumlahLembar;
                $totalInvestasi = ($existing['jumlah_lembar'] * $existing['harga_beli_rata_rata'])
                                + ($jumlahLembar * $hargaBeli);
                $avgHargaBaru = $totalInvestasi / $totalLembar;

                $model->update($existing['id'], [
                    'jumlah_lembar'        => $totalLembar,
                    'harga_beli_rata_rata' => $avgHargaBaru,
                    'updated_at'           => date('Y-m-d H:i:s'),
                ]);
            } else {
                $model->insert([
                    'user_id'              => $userId,
                    'stock_symbol'         => $data['stock_symbol'],
                    'jumlah_lembar'        => $jumlahLembar,
                    'harga_beli_rata_rata' => $hargaBeli,
                    'created_at'           => date('Y-m-d H:i:s'),
                    'updated_at'           => date('Y-m-d H:i:s'),
                ]);
            }
        } elseif ($data['tipe'] === 'SELL_STOCK' && $existing) {
            $sisaLembar = $existing['jumlah_lembar'] - $jumlahLembar;

            if ($sisaLembar > 0) {
                $model->update($existing['id'], [
                    'jumlah_lembar' => $sisaLembar,
                    'updated_at'    => date('Y-m-d H:i:s'),
                ]);
            } else {
                // Jika semua lembar dijual, hapus portofolio
                $model->delete($existing['id']);
            }
        } else {
            return $this->failNotFound('Portofolio saham tidak ditemukan untuk dijual.');
        }

        return $this->respondCreated(['message' => 'Portofolio berhasil diperbarui']);
    }
}
