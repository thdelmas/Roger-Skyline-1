<?php  //Start the Session
	echo '<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS" crossorigin="anonymous">';
if (isset($_POST['username']) and isset($_POST['password'])){
	$username = $_POST['username'];
	$password = $_POST['password'];
	echo '<div class="jumbotron">';
	if ($username == $password)
	{
		echo "<h1>Bravo !</h1>";
	}
	else
	{
		echo "<h1>Dommage</h1>";
	}
	echo "<p class='lead'></br></br></br>je sais c'est rudimentaire</p>";
	echo '</div>';
}
else
{
	echo '
<div class="jumbotron">
<h1>Hey hey !</h1></br><h1>Viens test ma super page de login !</h1></br>
<form class="form-signin" method="POST">
		<div class="input-group">
		<input type="text" name="username" class="form-control" placeholder="Username" required>
		<label for="inputPassword" class="sr-only">Password</label>
		<input type="password" name="password" id="inputPassword" class="form-control" placeholder="Password" required>
		<button class="btn btn-lg btn-primary btn-block" type="submit">Login</button>
	</form>
		</div>
';
}
?>
