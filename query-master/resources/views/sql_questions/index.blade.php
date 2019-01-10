<?php $user = Auth()->user(); ?>
<?php if(true === (bool)$user->is_trainer): ?>
	<p>
		<a href="<?= route('question.create') ?>" class="btn btn-info float-right" style="color: white !important">Add New</a>
	</p>
<?php endif ?>

<?php if ($sqlQuestions->isEmpty()): ?>
	<p>No questions.</p>
<?php else: ?>
	<table class="table">
	  <thead>
	    <tr>
	      <th scope="col">#</th>
	      <th scope="col">DB Name</th>
	      <th scope="col">Question</th>
	      <?php if ((bool)$user->is_trainer): ?>
		      <th scope="col">Correct Answer</th>
		      <th scope="col">Correct Result</th>
		      <th scope="col">Is Public</th>
		  <?php endif ?>
	      <th scope="col">Action</th>
	    </tr>
	  </thead>
	  <tbody>
	  	<?php foreach ($sqlQuestions as $key => $sqlQuestion): ?>
	  		<tr>
		      <th scope="row"><?= ++$key ?></th>
		      <td><?= $sqlQuestion->db_name ?></td>
		      <td><?= $sqlQuestion->question_text ?></td>
		      <?php if ((bool)$user->is_trainer): ?>
			      <td><?= $sqlQuestion->correct_answer ?></td>
			      <td><?= $sqlQuestion->correct_result ?></td>
			      <td><?= (1 === (int)$sqlQuestion->is_public) ? 'Yes' : 'No' ?></td>
			      <td><a href="<?= route('answer.index') ?>?question_id=<?= $sqlQuestion->question_id ?>&question=<?= $sqlQuestion->question_text ?>" class="btn btn-info btn-sm" style="color: white">View Answers</a></td>
			  <?php else: ?>
			  	  <td><a href="<?= route('answer.create', $sqlQuestion->question_id) ?>?question=<?= $sqlQuestion->question_text ?>" class="btn btn-info btn-sm" style="color: white">Give Answer</a></td>
		      <?php endif ?>
		      
		    </tr>
	  	<?php endforeach ?>
	  </tbody>
	</table>
<?php endif ?>