<?php

namespace App\Controllers\Api;

use App\Models\UsersModel; // Gunakan Model yang sudah kita buat
use CodeIgniter\API\ResponseTrait;
use CodeIgniter\Controller;
use Firebase\JWT\JWT; // Library JWT yang baru diinstal

class Auth extends Controller
{
    // ResponseTrait memudahkan kita untuk format respons JSON
    use ResponseTrait;

    /**
     * Endpoint: POST /api/register
     * Body: nama, email, password
     */
    public function register()
    {

        $model = new UsersModel();

        // 1. Ambil data dari request
        // ...
        // ...
        $data = [
            'nama' => $this->request->getPost('nama'),
            'email' => $this->request->getPost('email'),
            'password_hash' => password_hash($this->request->getPost('password'), PASSWORD_BCRYPT),
        ];
        // ...
        // ...

        // 3. Simpan ke database menggunakan Model
        // Model akan otomatis menjalankan validasi yang ada di UsersModel
        if ($model->save($data) === false) {
            // Jika validasi gagal, kirim error 400
            return $this->fail($model->errors(), 400);
        }

        // 4. Kirim respons sukses
        return $this->respondCreated([
            'status' => 'success',
            'message' => 'User berhasil terdaftar'
        ]);
    }

    /**
     * Endpoint: POST /api/login
     * Body: email, password
     */
    public function login()
    {
        $model = new UsersModel();

        // 1. Ambil data login
        $email = $this->request->getVar('email');
        $password = $this->request->getVar('password');

        // 2. Cari user berdasarkan email
        $user = $model->where('email', $email)->first();

        if (!$user) {
            // Jika email tidak ditemukan
            return $this->failNotFound('Email tidak ditemukan');
        }

        // 3. Verifikasi password
        if (!password_verify($password, $user['password_hash'])) {
            // Jika password salah
            return $this->fail('Password salah', 401); // 401 Unauthorized
        }

        // === 4. Login Berhasil: Buat Token JWT ===

        $key = getenv('JWT_SECRET');
        $iat = time();
        $exp = $iat + 3600;

        $payload = [
            'iss' => 'ci4api',
            'aud' => 'flutterapp',
            'iat' => $iat,
            'exp' => $exp,
            'data' => [
                'user_id' => $user['id'],
                'email' => $user['email'],
                'nama' => $user['nama'],
                'status_kyc' => $user['status_kyc'], // <-- TAMBAHKAN INI
            ],
        ];

        $token = JWT::encode($payload, $key, 'HS256');

        return $this->respond([
            'status' => 'success',
            'message' => 'Login berhasil',
            'token' => $token,
            'status_kyc' => $user['status_kyc'] // <-- KIRIM JUGA DI SINI
        ]);

        // 5. Generate token
        $token = JWT::encode($payload, $key, 'HS256');

        // 6. Kirim token ke Flutter
        return $this->respond([
            'status' => 'success',
            'message' => 'Login berhasil',
            'token' => $token
        ]);
    }
}