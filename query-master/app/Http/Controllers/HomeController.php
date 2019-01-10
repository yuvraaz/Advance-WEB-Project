<?php

namespace App\Http\Controllers;

use App\SqlQuestion;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct(SqlQuestion $sqlQuestion)
    {
        $this->sqlQuestion = $sqlQuestion;
        $this->middleware('auth');
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function index()
    {
        $sqlQuestions = $this->sqlQuestion->all();
        return view('home', compact('sqlQuestions'));
    }
}
