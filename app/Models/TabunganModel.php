<?php

namespace App\Models;

use CodeIgniter\Model;

class TabunganModel extends Model
{
    protected $table            = 'tabungan';
    protected $primaryKey       = 'id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';

    // Field yang boleh diisi
    protected $allowedFields    = [
        'user_id', 
        'nama_tabungan', 
        'target_jumlah', 
        'jumlah_sekarang'
    ];

    // Menggunakan timestamp
    protected $useTimestamps = true;
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';

    // Aturan validasi
    protected $validationRules      = [
        'user_id'       => 'required|numeric',
        'nama_tabungan' => 'required|min_length[3]',
        'target_jumlah' => 'permit_empty|decimal',
    ];
}