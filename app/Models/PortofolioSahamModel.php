<?php

namespace App\Models;

use CodeIgniter\Model;

class PortofolioSahamModel extends Model
{
    protected $table = 'portofolio_saham';
    protected $primaryKey = 'id';

    protected $allowedFields = [
        'user_id',
        'stock_symbol',
        'jumlah_lembar',
        'harga_beli_rata_rata',
        'created_at',
        'updated_at',
    ];

    protected $useTimestamps = false; // kita isi manual
}
