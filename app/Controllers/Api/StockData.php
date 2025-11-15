<?php

namespace App\Controllers\Api;

use CodeIgniter\API\ResponseTrait;
use CodeIgniter\Controller;

class StockData extends Controller
{
    use ResponseTrait;

    /**
     * Gateway untuk Alpha Vantage (Saham US / Global)
     * Endpoint: GET /api/stock/quote/{symbol}
     */
    public function getQuote($symbol)
    {
        $cacheKey = "stock_quote_" . strtoupper($symbol);
        $cacheDuration = 600;

        if ($data = cache($cacheKey)) {
            return $this->respond($data);
        }

        $apiKey = getenv('ALPHAVANTAGE_KEY');
        if (empty($apiKey)) {
            return $this->failServerError('API Key AlphaVantage belum di-set di .env');
        }

        $symbolFinal = strtoupper($symbol);

        $client = \Config\Services::curlrequest([
            'baseURI' => 'https://www.alphavantage.co/',
            'timeout' => 10,
        ]);

        try {
            $response = $client->get('query', [
                'query' => [
                    'function' => 'GLOBAL_QUOTE',
                    'symbol' => $symbolFinal,
                    'apikey' => $apiKey,
                ]
            ]);
        } catch (\Exception $e) {
            return $this->failServerError('Gagal terhubung ke AlphaVantage: ' . $e->getMessage());
        }

        $body = json_decode($response->getBody(), true);

        // 🔥 Fallback jika kena rate limit atau respons kosong
        if (isset($body['Information']) || isset($body['Note'])) {
            return $this->respond([
                'symbol' => $symbolFinal,
                'price' => 123.45,
                'change_percent' => 0.56,
                'last_updated' => date('Y-m-d'),
                'fallback' => true,
                'message' => 'Data asli tidak tersedia. Ini adalah data dummy karena limit AlphaVantage sudah tercapai.'
            ]);
        }

        $globalQuote = $body['Global Quote'] ?? null;

        if (empty($globalQuote) || empty($globalQuote['01. symbol'])) {
            return $this->respond([
                'symbol' => $symbolFinal,
                'price' => 123.45,
                'change_percent' => 0.56,
                'last_updated' => date('Y-m-d'),
                'fallback' => true,
                'message' => 'Simbol tidak ditemukan. Ini adalah data dummy untuk menjaga UI tetap jalan.'
            ]);
        }

        $cleanData = [
            'symbol' => $globalQuote['01. symbol'],
            'price' => (float) $globalQuote['05. price'],
            'change_percent' => (float) rtrim($globalQuote['10. change percent'], '%'),
            'last_updated' => $globalQuote['07. latest trading day'],
            'fallback' => false
        ];

        cache()->save($cacheKey, $cleanData, $cacheDuration);

        return $this->respond($cleanData);
    }

    public function getChart($symbol)
    {
        $apiKey = getenv('ALPHAVANTAGE_KEY');
        if (empty($apiKey)) {
            return $this->failServerError('API Key AlphaVantage belum di-set di .env');
        }

        $symbolFinal = strtoupper($symbol);

        $client = \Config\Services::curlrequest([
            'baseURI' => 'https://www.alphavantage.co/',
            'timeout' => 10,
        ]);

        try {
            $response = $client->get('query', [
                'query' => [
                    'function' => 'TIME_SERIES_DAILY',
                    'symbol' => $symbolFinal,
                    'apikey' => $apiKey,
                    'outputsize' => 'compact' // compact = 100 hari terakhir, full = semua data
                ]
            ]);
        } catch (\Exception $e) {
            return $this->failServerError('Gagal terhubung ke AlphaVantage: ' . $e->getMessage());
        }

        $body = json_decode($response->getBody(), true);
        $timeSeries = $body['Time Series (Daily)'] ?? null;

        if (empty($timeSeries)) {
            return $this->failNotFound("Data chart saham $symbolFinal tidak ditemukan di AlphaVantage.");
        }

        // Ambil data tanggal & harga penutupan
        $chartData = [];
        foreach ($timeSeries as $date => $values) {
            $chartData[] = [
                'date' => $date,
                'close' => (float) $values['4. close']
            ];
        }

        // Urutkan berdasarkan tanggal (ascending)
        usort($chartData, fn($a, $b) => strtotime($a['date']) <=> strtotime($b['date']));

        $cleanData = [
            'symbol' => $symbolFinal,
            'chart' => $chartData
        ];

        return $this->respond($cleanData);
    }

}