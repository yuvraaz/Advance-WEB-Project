@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card">
                <div class="card-header">
                	<?php if (isset($question)): ?>
                		Ansers to <b><i>'<?= $question ?>'</i></b>
                	<?php else : ?>
                		My Answers
                	<?php endif ?>
                	
                	<a href="{{ route('home') }}" class="btn btn-info btn-sm float-right" style="color: white">Back</a>
                </div>

                <div class="card-body">
                	<?php if ($answers->isEmpty()): ?>
						<p>No answers.</p>
					<?php else: ?>
						<table class="table">
						  <thead>
						    <tr>
						      <th scope="col">#</th>
						      <th scope="col">Student</th>
						      <th scope="col">Answer</th>
						      <th scope="col">Result</th>
						      <th scope="col">Givent At</th>
						      <th scope="col">Is Correct?</th>
						    </tr>
						  </thead>
						  <tbody>
						  	<?php foreach ($answers as $key => $answer): ?>
						  		<tr>
							      <th scope="row"><?= ++$key ?></th>
							      <td><?= $answer->trainee_id ?></td>
							      <td><?= $answer->answer ?></td>
							      <td><?= $answer->result ?></td>
							      <td><?= $answer->given_at ?></td>
							      <td><?= (1 === (int)$answer->gives_correct_result) ? 'Yes' : 'No' ?></td>
							    </tr>
						  	<?php endforeach ?>
						  </tbody>
						</table>
					<?php endif ?>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
