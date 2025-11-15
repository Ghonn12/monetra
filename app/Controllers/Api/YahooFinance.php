<?php

namespace App\Controllers\Api;

use CodeIgniter\API\ResponseTrait;
use CodeIgniter\Controller;

class YahooFinance extends Controller
{
    use ResponseTrait;

    /**
     * Ambil ringkasan harga saham dari Yahoo Finance (via RapidAPI)
     */
    public function getQuote($symbol)
    {
        $apiKey  = getenv('RAPIDAPI_KEY');
        $apiHost = getenv('RAPIDAPI_HOST');

        if (empty($apiKey) || empty($apiHost)) {
            return $this->failServerError('API Key/Host RapidAPI belum di-set di .env');
        }

        // Pastikan simbol tidak double .JK
        $symbolJK = strtoupper($symbol);
        if (!str_ends_with($symbolJK, '.JK')) {
            $symbolJK .= '.JK';
        }

        $cacheKey      = "yahoo_quote_" . $symbolJK;
        $cacheDuration = 600;

        if ($data = cache($cacheKey)) {
            return $this->respond($data);
        }

        $client = \Config\Services::curlrequest([
            'baseURI' => 'https://' . $apiHost,
            'timeout' => 10,
        ]);

        try {
            $response = $client->get('/market/v2/get-quotes', [
                'query' => [
                    'region'  => 'ID',
                    'symbols' => $symbolJK
                ],
                'headers' => [
                    'X-RapidAPI-Key'  => $apiKey,
                    'X-RapidAPI-Host' => $apiHost
                ]
            ]);
        } catch (\Exception $e) {
            return $this->failServerError('Gagal terhubung ke RapidAPI: ' . $e->getMessage());
        }

        $body = json_decode($response->getBody());

        $result = $body->quoteResponse->result[0] ?? null;

        if (!$result || empty($result->regularMarketPrice)) {
            return $this->failNotFound("Data saham $symbolJK tidak ditemukan di Yahoo Finance.");
        }

        $cleanData = [
            'symbol'         => $result->symbol ?? $symbolJK,
            'longName'       => $result->longName ?? $result->shortName ?? '',
            'price'          => $result->regularMarketPrice ?? null,
            'change_percent' => $result->regularMarketChangePercent ?? null,
            'last_updated'   => date('Y-m-d H:i:s', $result->regularMarketTime ?? time())
        ];

        cache()->save($cacheKey, $cleanData, $cacheDuration);

        return $this->respond($cleanData);
    }

    /**
     * Ambil data chart saham (historical prices) dari Yahoo Finance (via RapidAPI)
     */
    public function getChart($symbol)
    {
        $apiKey  = getenv('RAPIDAPI_KEY');
        $apiHost = getenv('RAPIDAPI_HOST');

        if (empty($apiKey) || empty($apiHost)) {
            return $this->failServerError('API Key/Host RapidAPI belum di-set di .env');
        }

        $symbolJK = strtoupper($symbol);
        if (!str_ends_with($symbolJK, '.JK')) {
            $symbolJK .= '.JK';
        }

        $client = \Config\Services::curlrequest([
            'baseURI' => 'https://' . $apiHost,
            'timeout' => 10,
        ]);

        try {
            $response = $client->get('/stock/v3/get-chart', [
                'query' => [
                    'interval'             => '1mo',
                    'region'               => 'ID',
                    'symbol'               => $symbolJK,
                    'range'                => '1y',
                    'includePrePost'       => 'false',
                    'useYfid'              => 'true',
                    'includeAdjustedClose' => 'true',
                    'events'               => 'capitalGain,div,split'
                ],
                'headers' => [
                    'X-RapidAPI-Key'  => $apiKey,
                    'X-RapidAPI-Host' => $apiHost
                ]
            ]);
        } catch (\Exception $e) {
            return $this->failServerError('Gagal terhubung ke RapidAPI: ' . $e->getMessage());
        }

        $body = json_decode($response->getBody());

        if (empty($body->chart->result)) {
            return $this->failNotFound("Data chart saham $symbolJK tidak ditemukan.");
        }

        $chart = $body->chart->result[0];

        $cleanData = [
            'symbol'             => $chart->meta->symbol ?? $symbolJK,
            'currency'           => $chart->meta->currency ?? '',
            'exchangeName'       => $chart->meta->exchangeName ?? '',
            'regularMarketPrice' => $chart->meta->regularMarketPrice ?? null,
            'previousClose'      => $chart->meta->previousClose ?? null,
            'chartTimestamp'     => $chart->timestamp ?? [],
            'chartClose'         => $chart->indicators->quote[0]->close ?? []
        ];

        return $this->respond($cleanData);
    }
}
