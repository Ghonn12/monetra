<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');


/**
 * --------------------------------------------------------------------
 * API Routes
 * --------------------------------------------------------------------
 */
$routes->group('api', function ($routes) {
    // --- Rute Autentikasi (Publik) ---
    $routes->post('register', 'Api\Auth::register');
    $routes->post('login', 'Api\Auth::login');

    // --- Rute Aman (Perlu Token JWT) ---
    
    // KYC
    $routes->post('kyc/upload', 'Api\Kyc::upload', ['filter' => 'jwt']);

    // Tabungan
    $routes->get('tabungan', 'Api\Tabungan::index', ['filter' => 'jwt']);
    $routes->post('tabungan', 'Api\Tabungan::create', ['filter' => 'jwt']);

    // --- PASTIKAN KEDUA RUTE INI ADA ---
    $routes->get('transaksi', 'Api\Transaksi::index', ['filter' => 'jwt']);
    $routes->post('transaksi', 'Api\Transaksi::create', ['filter' => 'jwt']);
    $routes->get('budget', 'Api\Budget::index', ['filter' => 'jwt']);
    $routes->post('budget', 'Api\Budget::create', ['filter' => 'jwt']);
    // ---
    
    // Gateway Saham AlphaVantage (Saham US)
    $routes->get('stock/quote/(:segment)', 'Api\StockData::getQuote/$1', ['filter' => 'jwt']);
    
    // Gateway Saham Yahoo (Saham Indo)
    $routes->get('yahoo/quote/(:segment)', 'Api\YahooFinance::getQuote/$1', ['filter' => 'jwt']);
    
    // Gateway Crypto (AlphaVantage)
    $routes->get('crypto/quote/(:segment)', 'Api\CryptoData::getQuote/$1', ['filter' => 'jwt']);

    // Gateway Chart (Yahoo)
    $routes->get('yahoo/chart/(:segment)', 'Api\YahooFinance::getChart/$1', ['filter' => 'jwt']);

    $routes->get('portofolio', 'Api\PortofolioSaham::index', ['filter' => 'jwt']);
    $routes->post('portofolio', 'Api\PortofolioSaham::create', ['filter' => 'jwt']);
});