<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');

Route::get('/questions/create', 'SqlQuestionController@create')->name('question.create');
Route::post('/questions', 'SqlQuestionController@store')->name('question.store');

Route::get('/answers', 'SqlAnswerController@index')->name('answer.index');
Route::get('/questions/{questionId}/answers/create', 'SqlAnswerController@create')->name('answer.create');
Route::post('/questions/{questionId}/answers/store', 'SqlAnswerController@store')->name('answer.store');
