<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class SqlQuestion extends Model
{
    protected $table = 'sql_question';

    protected $primaryKey = 'question_id';

    public $timestamps = false;

    protected $guarded = [];
}
