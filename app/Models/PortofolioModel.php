<?php

namespace App\Models;

use CodeIgniter\Model;

class PortofolioModel extends Model
{
    // Nama tabel di database (sesuai migrasi)
    protected $table            = 'portofolio_saham'; 
    
    protected $primaryKey       = 'id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';

    // Field yang boleh diisi
    protected $allowedFields    = [
        'user_id', 
        'stock_symbol', 
        'jumlah_lembar', 
        'harga_beli_rata_rata'
    ];

    // Menggunakan timestamp
    protected $useTimestamps = true;
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';

    // Aturan validasi
    protected $validationRules      = [
        'user_id'       => 'required|numeric',
        'stock_symbol'  => 'required',
        'jumlah_lembar' => 'required|numeric',
        'harga_beli_rata_rata' => 'required|decimal',
    ];
}