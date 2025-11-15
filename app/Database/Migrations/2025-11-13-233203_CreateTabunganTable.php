<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateTabunganTable extends Migration
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
            'nama_tabungan' => [
                'type'       => 'VARCHAR',
                'constraint' => '255',
                'comment'    => 'Cth: Dana Darurat, Beli Rumah',
            ],
            'target_jumlah' => [
                'type'       => 'DECIMAL',
                'constraint' => '20,2',
                'default'    => 0.00,
            ],
            'jumlah_sekarang' => [
                'type'       => 'DECIMAL',
                'constraint' => '20,2',
                'default'    => 0.00,
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
        
        // Membuat Foreign Key
        // Ini mengasumsikan 'user_id' di tabel 'tabungan' 
        // merujuk ke 'id' di tabel 'users'
        // 'CASCADE' berarti jika user dihapus, tabungannya juga ikut terhapus.
        $this->forge->addForeignKey('user_id', 'users', 'id', 'CASCADE', 'CASCADE');
        
        $this->forge->createTable('tabungan');
    }

    public function down()
    {
        $this->forge->dropTable('tabungan');
    }
}