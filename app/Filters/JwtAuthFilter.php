<?php

namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Config\Services;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Exception;

class JwtAuthFilter implements FilterInterface
{
    /**
     * Dijalankan SEBELUM controller
     */
    public function before(RequestInterface $request, $arguments = null)
    {
        $response = Services::response();
        
        // 1. Ambil header Authorization
        $authHeader = $request->getHeaderLine('Authorization');

        if (!$authHeader) {
            // Jika tidak ada header Authorization
            return $response->setJSON([
                'status' => 401,
                'error' => 401,
                'messages' => ['error' => 'Token JWT tidak ada atau tidak valid']
            ])->setStatusCode(401);
        }

        // 2. Pisahkan "Bearer" dari token-nya
        $token = null;
        if (preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
            $token = $matches[1];
        }

        if (!$token) {
            // Jika format header-nya salah
            return $response->setJSON([
                'status' => 401,
                'error' => 401,
                'messages' => ['error' => 'Format token tidak valid']
            ])->setStatusCode(401);
        }

        try {
            // 3. Ambil secret key dari .env
            $key = getenv('JWT_SECRET');

            // 4. Decode token
            $decoded = JWT::decode($token, new Key($key, 'HS256'));

            // 5. (PENTING) Simpan data user ke request
            // Ini agar controller nanti bisa tahu siapa user yang login
            $request->user = $decoded->data;
            
            return $request; // Lanjutkan ke controller

        } catch (Exception $e) {
            // 6. Tangani jika token tidak valid (expired, signature salah, dll)
            return $response->setJSON([
                'status' => 401,
                'error' => 401,
                'messages' => ['error' => 'Token tidak valid: ' . $e->getMessage()]
            ])->setStatusCode(401);
        }
    }

    /**
     * Dijalankan SETELAH controller (tidak kita gunakan)
     */
    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        // Tidak perlu melakukan apa-apa di sini
    }
}