<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
    <style>
        /* Global Styles */
        body {
            font-family: Arial, sans-serif;
            background: url('bg-image.jpg') no-repeat center center/cover;
            height: 100vh;
            display: flex;
            justify-content: flex-end; /* Moves content to the right */
            align-items: center;
            margin: 0;
            padding-right: 10%;
            color: white;
        }

        /* Form Container - No Background */
        .container {
            width: 350px;
            text-align: center;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); /* Soft shadow */
            backdrop-filter: blur(10px); /* Glass effect */
            -webkit-backdrop-filter: blur(10px); /* Safari Support */
            border: none; /* Removed border */
        }

        h2 {
            font-size: 24px;
            color: #f1c40f;
        }

        /* Input Fields */
        .input-group {
            margin-bottom: 15px;
            text-align: left;
        }

        .input-group label {
            display: block;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .input-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 5px;
            font-size: 16px;
            background: rgba(255, 255, 255, 0.2); /* Light transparent white */
            color: white;
        }

        .input-group input::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        /* Submit Button */
        .btn {
            background: #3498db;
            color: white;
            padding: 12px;
            width: 100%;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn:hover {
            background: #2980b9;
        }

        /* Login Link */
        .login-link {
            margin-top: 15px;
            font-size: 14px;
        }

        .login-link a {
            color: #f1c40f;
            text-decoration: none;
            font-weight: bold;
        }

        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>User Registration</h2>
        <form action="RegisterServlet" method="post">
            
            <div class="input-group">
                <label for="name">Name:</label>
                <input type="text" name="name" id="name" required placeholder="Enter your name">
            </div>

            <div class="input-group">
                <label for="address">Address:</label>
                <input type="text" name="address" id="address" placeholder="Enter your address">
            </div>

            <div class="input-group">
                <label for="contact">Contact:</label>
                <input type="text" name="contact" id="contact" required placeholder="Enter your contact number">
            </div>

            <div class="input-group">
                <label for="email">Email:</label>
                <input type="email" name="email" id="email" required placeholder="Enter your email">
            </div>

            <div class="input-group">
                <label for="password">Password:</label>
                <input type="password" name="password" id="password" required placeholder="Enter your password">
            </div>

            <div class="input-group">
                <label for="deposit">Initial Deposit:</label>
                <input type="number" name="deposit" id="deposit" required placeholder="Enter initial deposit">
            </div>

            <input type="submit" class="btn" value="Register">
        </form>

        <!-- Login Link -->
        <p class="login-link">
            Already have an account? <a href="login.jsp">Login here</a>
        </p>
    </div>

</body>
</html>
