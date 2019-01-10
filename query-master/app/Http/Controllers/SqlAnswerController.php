<?php

namespace App\Http\Controllers;

use App\Sheet;
use App\SqlAnswer;
use Illuminate\Http\Request;

class SqlAnswerController extends Controller
{
    function __construct(SqlAnswer $sqlAnswer)
    {
    	$this->sqlAnswer = $sqlAnswer;
    }

    public function index(Request $request)
    {
    	$questionId = $request->get('question_id');

    	if(empty($questionId)) {
    		$answers = $this->sqlAnswer->where('trainee_id', Auth()->user()->user_id)->get();
    		return view('sql_answers.index', compact('answers'));
    	}

    	$answers = $this->sqlAnswer->where('question_id', $questionId)->get();

    	return view('sql_answers.index', compact('answers', 'question'));
    }

    public function create($questionId, Request $request)
    {
    	$question = $request->get('question');
    	return view('sql_answers.create', compact('question', 'questionId'));
    }

    public function store($questionId, Request $request, Sheet $sheet)
    {
    	$sheetData = $sheet->create([
    		'trainee_id' => Auth()->user()->user_id,
    		'evaluation_id' => 1,
    		'started_at' => date('Y-m-d H:i:s'),
    	]);

    	$this->sqlAnswer->create([
    		'question_id' => $questionId,
    		'answer' => $request->get('answer'),
    		'result' => $request->get('result'),
    		'given_at' => date('Y-m-d H:i:s'),
    		'trainee_id' => Auth()->user()->user_id,
    		'evaluation_id' => 1
    	]);

    	session('status', 'New answer given for question \'' . $request->get('question') . '\'');
    	return redirect()->route('home');
    }
}
