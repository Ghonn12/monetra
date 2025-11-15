<?php

namespace App\Controllers\Api;

use App\Models\BudgetModel;
use CodeIgniter\API\ResponseTrait;
use CodeIgniter\Controller;

class Budget extends Controller
{
    use ResponseTrait;

    /**
     * Endpoint: GET /api/budget
     * Mengambil semua kategori budget milik user
     */
    public function index()
    {
        $model = new BudgetModel();
        $userId = $this->request->user->user_id;

        $data = $model->where('user_id', $userId)
            ->orderBy('category_name', 'ASC')
            ->findAll();

        return $this->respond($data);
    }

    /**
     * Endpoint: POST /api/budget
     * Membuat kategori budget baru
     */
    public function create()
    {
        $data = $this->request->getPost();;

        if (empty($data['category_name']) || empty($data['allocated_amount'])) {
            return $this->failValidationErrors('Field category_name dan allocated_amount wajib diisi.');
        }

        $budgetModel = new BudgetModel();

        try {
            $budgetModel->save([
                'user_id' => $this->request->user->user_id ?? 1, // ✅ pakai request->user
                'category_name' => $data['category_name'],
                'allocated_amount' => $data['allocated_amount'],
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),
            ]);

            return $this->respondCreated([
                'message' => 'Budget berhasil dibuat',
                'data' => $data
            ]);
        } catch (\Throwable $e) {
            return $this->failServerError('Gagal membuat budget: ' . $e->getMessage());
        }
    }




}