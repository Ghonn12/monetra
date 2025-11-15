<?php

namespace App\Models;

use CodeIgniter\Model;

class BudgetModel extends Model
{
    protected $table            = 'budgets';
    protected $primaryKey       = 'id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';

    // --- PASTIKAN BAGIAN INI TERISI ---
    // Ini adalah 'daftar izin' field yang boleh disimpan
    protected $allowedFields    = [
        'user_id',
        'category_name',
        'allocated_amount'
    ];
    // ---

    // Menggunakan created_at dan updated_at secara otomatis
    protected $useTimestamps = true;
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';
}