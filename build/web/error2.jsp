<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700&family=Open+Sans&display=swap');

        body {
            font-family: 'Open Sans', sans-serif;
            background-color: #1d2a35;
            color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .container {
            background-color: #121e2a;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }

        h1 {
            font-family: 'Merriweather', serif;
            color: #f5c776;
            margin-bottom: 20px;
            font-size: 2rem;
        }

        .message {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 30px;
            color: #e74c3c;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
        }

        a:hover {
            background-color: #2980b9;
        }

        @media (max-width: 600px) {
            .container {
                margin: 20px;
                padding: 20px;
            }

            h1 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <%
        String heading = (String) request.getAttribute("heading");
        String message = (String) request.getAttribute("message");
    %>
    <h1><%= heading %></h1>
    <div class="message">
        <%= message %>
    </div>
    <a href="Login.jsp">Login Page</a>
</div>

</body>
</html>
