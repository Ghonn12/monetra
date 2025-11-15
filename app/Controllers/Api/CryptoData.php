<?php

namespace App\Controllers\Api;

use CodeIgniter\API\ResponseTrait;
use CodeIgniter\Controller;

class CryptoData extends Controller
{
    use ResponseTrait;

    /**
     * Endpoint: GET /api/crypto/quote/{symbol}
     * Mengambil data quote crypto (vs USD) dari Alpha Vantage
     * (Wajib terautentikasi)
     */
    public function getQuote($symbol)
    {
        $apiKey = getenv('ALPHAVANTAGE_KEY');
        if (empty($apiKey)) {
            return $this->failServerError('API Key untuk Alpha Vantage belum di-set di .env');
        }

        $symbolUpper   = strtoupper($symbol);
        $cacheKey      = "crypto_quote_" . $symbolUpper;
        $cacheDuration = 300;

        if ($data = cache($cacheKey)) {
            return $this->respond($data);
        }

        $client = \Config\Services::curlrequest([
            'baseURI' => 'https://www.alphavantage.co/',
            'timeout' => 10,
        ]);

        try {
            $response = $client->get('query', [
                'query' => [
                    'function'      => 'CURRENCY_EXCHANGE_RATE',
                    'from_currency' => $symbolUpper,
                    'to_currency'   => 'USD',
                    'apikey'        => $apiKey,
                ]
            ]);
        } catch (\Exception $e) {
            return $this->failServerError('Gagal terhubung ke Alpha Vantage: ' . $e->getMessage());
        }

        $body = json_decode($response->getBody(), true);

        // 🔥 Fallback jika kena rate limit atau respons kosong
        if (isset($body['Note']) || isset($body['Information'])) {
            return $this->respond([
                'symbol'       => $symbolUpper,
                'name'         => 'Crypto Dummy',
                'price_usd'    => 12345.67,
                'last_updated' => date('Y-m-d H:i:s'),
                'fallback'     => true,
                'message'      => 'Data asli tidak tersedia. Ini adalah data dummy karena limit AlphaVantage sudah tercapai.'
            ]);
        }

        $quote = $body['Realtime Currency Exchange Rate'] ?? null;

        if (empty($quote) || empty($quote['1. From_Currency Code'])) {
            return $this->respond([
                'symbol'       => $symbolUpper,
                'name'         => 'Crypto Dummy',
                'price_usd'    => 12345.67,
                'last_updated' => date('Y-m-d H:i:s'),
                'fallback'     => true,
                'message'      => 'Simbol tidak ditemukan. Ini adalah data dummy untuk menjaga UI tetap jalan.'
            ]);
        }

        $cleanData = [
            'symbol'       => $quote['1. From_Currency Code'],
            'name'         => $quote['2. From_Currency Name'],
            'price_usd'    => (float) $quote['5. Exchange Rate'],
            'last_updated' => $quote['6. Last Refreshed'],
            'fallback'     => false
        ];

        cache()->save($cacheKey, $cleanData, $cacheDuration);

        return $this->respond($cleanData);
    }
}
