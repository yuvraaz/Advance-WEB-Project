<?php

namespace App\Http\Controllers;

use App\SqlQuestion;
use Illuminate\Http\Request;

class SqlQuestionController extends Controller
{
    function __construct(SqlQuestion $sqlQuestion)
    {
    	$this->sqlQuestion = $sqlQuestion;
    }

    public function create()
    {
    	return view('sql_questions.create');
    }

    public function store(Request $request)
    {
    	$this->sqlQuestion->create([
    		'db_name' => 'my_db',
    		'question_text' => $request->get('question'),
    		'correct_answer' => $request->get('correct_answer'),
    		'correct_result' => $request->get('correct_result'),
    		'is_public' => 'on' === $request->get('public') ? 1 : 0,
    		'theme_id' => 1,
    		'author_id' => Auth()->user()->user_id
    	]);

    	session('status', 'New question \'' . $request->get('question') . '\' successfully added.');
    	return redirect()->route('home');
    }
}
