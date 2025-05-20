<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>User Login</title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700&family=Open+Sans&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Open Sans', sans-serif;
            background-color: #1d2a35;
            color: #f5f5f5;
            line-height: 1.6;
            padding-top: 80px;
        }

        a {
            color: #f5c776;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        a:hover {
            color: #ffdb70;
        }

        header {
            background-color: #121e2a;
            padding: 1rem 0;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
            border-bottom: 3px solid #f5c776;
        }

        header .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-family: 'Merriweather', serif;
            font-size: 2rem;
            font-weight: bold;
            color: #f5c776;
        }

        nav ul {
            list-style: none;
            display: flex;
        }

        nav ul li {
            margin-left: 1.5rem;
        }

        nav ul li a {
            color: #ffffff;
            padding: 0.5rem;
            border-bottom: 2px solid transparent;
        }

        nav ul li a.active,
        nav ul li a:hover {
            border-bottom: 2px solid #f5c776;
        }

        .login-container {
            max-width: 500px;
            margin: 5rem auto;
            background-color: #121e2a;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            font-family: 'Merriweather', serif;
            color: #f5c776;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            font-size: 1.1rem;
            color: #f5f5f5;
            margin-bottom: 8px;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1rem;
            background-color: #f5f5f5;
            color: #333;
        }

        input[type="submit"] {
            background-color: #f5c776;
            color: #1d2a35;
            padding: 0.75rem;
            border: none;
            font-size: 1.1rem;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #ffdb70;
        }

        p {
            text-align: center;
            font-size: 1rem;
        }

        p a {
            color: #f5c776;
            text-decoration: none;
        }

        p a:hover {
            text-decoration: underline;
        }

        .error-message {
            color: red;
            text-align: center;
            font-weight: bold;
            margin-top: 20px;
        }
    </style>
</head>
<body>


    <div class="login-container">
        <h2>Login to Your Account</h2>
        <form action="LoginServlet.do" method="post">
            <label for="email">Email:</label>
            <input type="text" id="email" name="email" required>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <input type="submit" value="Login">
        </form>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <p><%= request.getAttribute("error") %></p>
            </div>
        <% } %>
        <br>
        <br>
        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
        <br>
        <p><a href = "index.html">Home Page</a></p>
    </div>

</body>
</html>
