<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Sheet extends Model
{
    protected $table = 'sheet';

    // protected $primaryKey = 'question_id';

    public $timestamps = false;

    protected $guarded = [];
}
