<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Login</title>
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

        /* Form Container - Glassmorphism Effect */
        .container {
            width: 350px;
            text-align: center;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); /* Soft shadow */
            backdrop-filter: blur(10px); /* Glass effect */
            -webkit-backdrop-filter: blur(10px); /* Safari Support */
            border: none; /* No border */
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

        /* Register Link */
        .register-link {
            margin-top: 15px;
            font-size: 14px;
        }

        .register-link a {
            color: #f1c40f;
            text-decoration: none;
            font-weight: bold;
        }

        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>User Login</h2>
        <form action="LoginServlet" method="post">
            
            <div class="input-group">
                <label for="emailOrContact">Email or Contact:</label>
                <input type="text" name="emailOrContact" id="emailOrContact" required placeholder="Enter your email or contact">
            </div>

            <div class="input-group">
                <label for="password">Password:</label>
                <input type="password" name="password" id="password" required placeholder="Enter your password">
            </div>

            <input type="submit" class="btn" value="Login">
        </form>

        <!-- Register Link -->
        <p class="register-link">
            Don't have an account? <a href="register.jsp">Register here</a>
        </p>
    </div>

</body>
</html>
