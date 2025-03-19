<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Banking System</title>
<style type="text/css">
/* styles.css */
body {
	font-family: Arial, sans-serif;
	background: url('bg-image.jpg') no-repeat center center/cover;
	height: 100vh;
	display: flex;
	justify-content: center;
	align-items: center;
	flex-direction: column;
	text-align: center;
	margin: 0;
	padding: 0;
	color: white;
}

.container {
	padding: 20px;
	border-radius: 10px;
	width: 50%;
	text-align: right; /* Align text to the right */
	align-self: flex-end; /* Move the container to the right */
	margin-right: 50px; /* Add spacing from the right edge */
}

h1 {
	font-size: 36px;
	margin: 0;
}

p {
	font-size: 18px;
	margin-top: 10px;
}

/* Login & Register options */
.nav-links {
	position: absolute;
	top: 20px;
	right: 20px;
}

.nav-links a {
	text-decoration: none;
	color: white;
	background: #3498db;
	padding: 10px 15px;
	border-radius: 5px;
	margin-left: 10px;
	transition: background 0.3s ease-in-out;
}

.nav-links a:hover {
	background: #2980b9;
}
</style>
</head>
<body>
	<!-- Navigation Links -->
	<div class="nav-links">
		<a href="login.jsp">Login</a> <a href="register.jsp">Register</a>
	</div>

	<!-- Welcome Message Container -->
	<div class="container">
		<h1>Welcome to the State Bank Of India ❤️</h1>
		<p>Manage your finances securely and efficiently.</p>
	</div>
</body>
</html>
