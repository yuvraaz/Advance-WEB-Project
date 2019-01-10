<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class SqlAnswer extends Model
{
    protected $table = 'sql_answer';

    // protected $primaryKey = 'question_id';

    public $timestamps = false;

    protected $guarded = [];
}
