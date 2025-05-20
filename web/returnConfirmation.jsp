<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Return Confirmation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            color: #333;
            text-align: center;
            margin-top: 50px;
        }

        .message {
            background-color: #d4edda;
            color: #155724;
            padding: 20px;
            border: 1px solid #c3e6cb;
            border-radius: 5px;
            font-size: 1.2rem;
            margin: 20px;
        }

        a {
            text-decoration: none;
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
        }

        a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="message">
        <h2><%= request.getAttribute("message") %></h2>
    </div>
    <a href="returnBook.jsp">Back to Borrowed Books</a>
</body>
</html>
