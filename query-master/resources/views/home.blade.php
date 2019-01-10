@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card">
                <div class="card-header">
                    Dashboard

                    <?php if (false === (bool)Auth()->user()->trainee_id): ?>
                        <a href="<?= route('answer.index') ?>" class="btn btn-info btn-sm float-right" style="color: white !important">My Answers</a>
                    <?php endif ?>
                </div>

                <div class="card-body">
                    @if (session('status'))
                        <div class="alert alert-success" role="alert">
                            {{ session('status') }}
                        </div>
                    @endif

                    @include('sql_questions.index', $sqlQuestions)
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
