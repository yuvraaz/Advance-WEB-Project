@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card">
                <div class="card-header">
                	Create New Question
                	<a href="{{ route('home') }}" class="btn btn-info btn-sm float-right" style="color: white">Back</a>
                </div>

                <div class="card-body">
                    <form method="post" action="<?= route('question.store') ?>">
                      {{ csrf_field() }}
					  <div class="form-group">
					    <label for="question">Question</label>
					    <input type="text" class="form-control" id="question" name="question" placeholder="Question">
					  </div>
					  <div class="form-group">
					    <label for="correct_answer">Correct Answer</label>
					    <input type="text" class="form-control" id="correct_answer" name="correct_answer" placeholder="Correct Answer">
					  </div>
					  <div class="form-group">
					    <label for="correct_result">Correct Result</label>
					    <input type="text" class="form-control" id="correct_result" name="correct_result" placeholder="Correct Result">
					  </div>
					  <div class="form-group form-check">
					    <input type="checkbox" name="public" class="form-check-input" id="public">
					    <label class="form-check-label" for="public">Make Public?</label>
					  </div>
					  <button type="submit" class="btn btn-primary">Submit</button>
					</form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
