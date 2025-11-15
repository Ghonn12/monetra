<?php

namespace App\Models;

use CodeIgniter\Model;

class UsersModel extends Model
{
    // Nama tabel di database
    protected $table = 'users';

    // Primary key tabel
    protected $primaryKey = 'id';

    // Menggunakan auto-increment
    protected $useAutoIncrement = true;

    // Tipe data yang dikembalikan
    protected $returnType = 'array'; // 'object' atau 'array'

    // Field yang diizinkan untuk diisi (mass assignment)
    // Ini PENTING untuk keamanan
    protected $allowedFields = [
        'nama',
        'email',
        'nomor_hp',
        'password_hash',
        'pin_transaksi_hash',
        // Tambahkan ini:
        'status_kyc',
        'ktp_image_path',
        'selfie_image_path'
    ];

    // Mengaktifkan penggunaan timestamp (created_at, updated_at)
    protected $useTimestamps = true;
    protected $createdField = 'created_at';
    protected $updatedField = 'updated_at';

    // (Opsional tapi Sangat Direkomendasikan) Aturan Validasi
    // Ini akan digunakan otomatis saat Anda memanggil $model->save()
    protected $validationRules = [
        'nama' => 'required|min_length[3]',
        'email' => 'required|valid_email|is_unique[users.email,id,{id}]',
        'nomor_hp' => 'permit_empty|is_unique[users.nomor_hp,id,{id}]',
    ];

    protected $validationMessages = [
        'email' => [
            'is_unique' => 'Email ini sudah terdaftar. Silakan gunakan email lain.',
        ],
        'nomor_hp' => [
            'is_unique' => 'Nomor HP ini sudah terdaftar.',
        ],
    ];

    protected $skipValidation = false;
}