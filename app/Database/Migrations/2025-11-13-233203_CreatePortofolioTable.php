<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreatePortofolioTable extends Migration
{
    public function up()
    {
        $this->forge->addField([
            'id' => [
                'type'           => 'INT',
                'constraint'     => 11,
                'unsigned'       => true,
                'auto_increment' => true,
            ],
            'user_id' => [
                'type'       => 'INT',
                'constraint' => 11,
                'unsigned'   => true,
            ],
            'stock_symbol' => [
                'type'       => 'VARCHAR',
                'constraint' => '20', // Cth: BBCA, GOTO
            ],
            'jumlah_lembar' => [
                'type'       => 'INT',
                'constraint' => 11,
            ],
            'harga_beli_rata_rata' => [
                'type'       => 'DECIMAL',
                'constraint' => '20,2',
                'comment'    => 'Harga average/rata-rata pembelian',
            ],
            'created_at' => [
                'type' => 'DATETIME',
                'null' => true,
            ],
            'updated_at' => [
                'type' => 'DATETIME',
                'null' => true,
            ],
        ]);
        $this->forge->addKey('id', true);
        $this->forge->addForeignKey('user_id', 'users', 'id', 'CASCADE', 'CASCADE');
        
        // Menambahkan unique key untuk pasangan user_id dan stock_symbol
        // Ini memastikan satu user hanya punya satu entri per saham.
        $this->forge->addUniqueKey(['user_id', 'stock_symbol']);
        
        $this->forge->createTable('portofolio_saham');
    }

    public function down()
    {
        $this->forge->dropTable('portofolio_saham');
    }
}