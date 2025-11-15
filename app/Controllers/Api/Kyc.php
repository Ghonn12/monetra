<?php

namespace App\Controllers\Api;

use App\Models\UsersModel; // <-- Gunakan backslash \
use CodeIgniter\API\ResponseTrait; // <-- Gunakan backslash \
use CodeIgniter\Controller; // <-- Gunakan backslash \

class Kyc extends Controller
{
    use ResponseTrait;

    /**
     * Endpoint: POST /api/kyc/upload
     * Meng-handle upload file KTP dan Selfie
     * (Wajib terautentikasi)
     */
    public function upload()
    {
        $model = new UsersModel();
        
        // 1. Ambil ID user dari token
        $userId = $this->request->user->user_id; // <-- Gunakan panah ->

        // 2. Aturan Validasi untuk file
        $rules = [
            'ktp' => [
                'label' => 'Foto KTP',
                'rules' => 'uploaded[ktp]|is_image[ktp]|mime_in[ktp,image/jpg,image/jpeg,image/png]|max_size[ktp,2048]',
            ],
            'selfie' => [
                'label' => 'Foto Selfie',
                'rules' => 'uploaded[selfie]|is_image[selfie]|mime_in[selfie,image/jpg,image/jpeg,image/png]|max_size[selfie,2048]',
            ],
        ];

        if (!$this->validate($rules)) { // <-- Gunakan panah ->
            // 3. Jika validasi gagal
            return $this->fail($this->validator->getErrors(), 400); // <-- Gunakan panah ->
        }

        // 4. Ambil file dari request
        $ktpFile = $this->request->getFile('ktp'); // <-- Gunakan panah ->
        $selfieFile = $this->request->getFile('selfie'); // <-- Gunakan panah ->

        // 5. Pindahkan file ke folder writable
        // Pastikan folder writable/uploads/kyc sudah ada dan bisa ditulis (writable)
        $ktpName = $userId . '_ktp_' . $ktpFile->getRandomName(); // <-- Gunakan panah ->
        $ktpFile->move(WRITEPATH . 'uploads/kyc', $ktpName); // <-- Gunakan panah ->

        $selfieName = $userId . '_selfie_' . $selfieFile->getRandomName(); // <-- Gunakan panah ->
        $selfieFile->move(WRITEPATH . 'uploads/kyc', $selfieName); // <-- Gunakan panah ->

        // 6. Update database
        $data = [
            'status_kyc'        => 'PENDING', // Ubah status jadi PENDING
            'ktp_image_path'    => 'kyc/' . $ktpName,
            'selfie_image_path' => 'kyc/' . $selfieName,
        ];

        if ($model->update($userId, $data) === false) { // <-- Gunakan panah ->
            return $this->fail($model->errors(), 400); // <-- Gunakan panah ->
        }

        // 7. Kirim respons sukses
        return $this->respond([ // <-- Gunakan panah ->
            'status' => 'success',
            'message' => 'Upload KYC berhasil, data sedang diverifikasi.',
            'status_kyc' => 'PENDING'
        ]);
    }
}