@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card">
                <div class="card-header">
                	New Answer
                	<a href="{{ route('home') }}" class="btn btn-info btn-sm float-right" style="color: white">Back</a>
                </div>

                <div class="card-body">
                    <form method="post" action="<?= route('answer.store', $questionId) ?>?question=<?= $question ?>">
                      {{ csrf_field() }}
					  <div class="form-group">
					    <label for="answer">Answer</label>
					    <input type="text" class="form-control" id="answer" name="answer" placeholder="Answer">
					  </div>
					  <div class="form-group">
					    <label for="result">Result</label>
					    <input type="text" class="form-control" id="result" name="result" placeholder="Result">
					  </div>
					  <button type="submit" class="btn btn-primary">Submit</button>
					</form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
