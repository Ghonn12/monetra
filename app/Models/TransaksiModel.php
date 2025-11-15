<?php

namespace App\Models;

use CodeIgniter\Model;

class TransaksiModel extends Model
{
    protected $table            = 'transaksi';
    protected $primaryKey       = 'id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';

    // Field yang boleh diisi
    protected $allowedFields    = [
        'user_id', 
        'tipe', 
        'status', 
        'jumlah', 
        'keterangan', 
        'kode_aset'
    ];

    // Menggunakan timestamp
    protected $useTimestamps = true;
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';

    // Aturan validasi
    protected $validationRules      = [
        'user_id' => 'required|numeric',
        'tipe'    => 'required|in_list[DEPOSIT,WITHDRAW,BUY_STOCK,SELL_STOCK,TOPUP_TABUNGAN]',
        'status'  => 'required|in_list[PENDING,SUCCESS,FAILED]',
        'jumlah'  => 'required|decimal',
    ];
}