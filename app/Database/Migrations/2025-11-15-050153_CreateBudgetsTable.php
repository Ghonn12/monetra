<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreateBudgetsTable extends Migration
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
            'category_name' => [
                'type'       => 'VARCHAR',
                'constraint' => '100',
                'comment'    => 'Cth: Makan, Transportasi, Hiburan',
            ],
            'allocated_amount' => [
                'type'       => 'DECIMAL',
                'constraint' => '20,2',
                'default'    => 0.00,
                'comment'    => 'Jumlah yang dianggarkan',
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
        $this->forge->createTable('budgets');
    }

    public function down()
    {
        $this->forge->dropTable('budgets');
    }
}