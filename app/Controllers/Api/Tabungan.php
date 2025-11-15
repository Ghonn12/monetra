<?php

namespace App\Controllers\Api;

use App\Models\TabunganModel; // Gunakan model tabungan
use CodeIgniter\API\ResponseTrait;
use CodeIgniter\Controller;

class Tabungan extends Controller
{
    use ResponseTrait;

    /**
     * Endpoint: GET /api/tabungan
     * Mengambil semua data tabungan milik user yang login
     * (Wajib terautentikasi)
     */
    public function index()
    {
        $model = new TabunganModel();

        // 1. Ambil ID user dari request
        // ID ini disuntikkan oleh JwtAuthFilter kita
        $userId = $this->request->user->user_id;

        // 2. Cari data tabungan HANYA untuk user tersebut
        $data = $model->where('user_id', $userId)->findAll();

        // 3. Kembalikan data
        return $this->respond($data);
    }

    /**
     * Endpoint: POST /api/tabungan
     * Membuat data tabungan baru untuk user yang login
     * (Wajib terautentikasi)
     */
    public function create()
    {
        $model = new TabunganModel();
        
        // 1. Ambil ID user dari request (sama seperti 'index')
        $userId = $this->request->user->user_id;

        // 2. Ambil data dari body request
        $data = [
            'user_id'       => $userId, // Set user_id secara otomatis
            'nama_tabungan' => $this->request->getPost('nama_tabungan'),
            'target_jumlah' => $this->request->getPost('target_jumlah'),
            'jumlah_sekarang' => 0 // Default 0 saat dibuat
        ];

        // 3. Simpan ke database
        if ($model->save($data) === false) {
            // Jika validasi model gagal
            return $this->fail($model->errors(), 400);
        }

        // 4. Kirim respons sukses
        return $this->respondCreated([
            'status' => 'success',
            'message' => 'Tabungan berhasil ditambahkan'
        ]);
    }
}