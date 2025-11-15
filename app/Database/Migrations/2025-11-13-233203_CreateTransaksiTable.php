<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateTransaksiTable extends Migration
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
            'tipe' => [
                'type'       => 'ENUM',
                'constraint' => ['DEPOSIT', 'WITHDRAW', 'BUY_STOCK', 'SELL_STOCK', 'TOPUP_TABUNGAN'],
                'default'    => 'DEPOSIT',
            ],
            'status' => [
                'type'       => 'ENUM',
                'constraint' => ['PENDING', 'SUCCESS', 'FAILED'],
                'default'    => 'PENDING',
            ],
            'jumlah' => [
                'type'       => 'DECIMAL',
                'constraint' => '20,2',
            ],
            'keterangan' => [
                'type'       => 'VARCHAR',
                'constraint' => '255',
                'null'       => true,
            ],
            'kode_aset' => [
                'type'       => 'VARCHAR',
                'constraint' => '50',
                'null'       => true,
                'comment'    => 'Cth: BBCA, GOTO, atau ID Tabungan',
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
        $this->forge->createTable('transaksi');
    }

    public function down()
    {
        $this->forge->dropTable('transaksi');
    }
}