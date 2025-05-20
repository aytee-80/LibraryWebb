<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="menu.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Added</title>
    <style>
        body {
            background-color: #f4f7fc;
            font-family: Arial, sans-serif;
            padding: 40px;
            text-align: center;
        }

        .message {
            background-color: #ffffff;
            border-left: 6px solid #2ecc71;
            padding: 20px;
            display: inline-block;
            border-radius: 6px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            font-size: 1.2rem;
            color: #2c3e50;
        }

        .button {
            display: inline-block;
            margin-top: 30px;
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

    <div class="message">
        <%= request.getAttribute("message") %>
    </div>

    <div>
        <a class="button" href="addBook.jsp">Add Another Book</a>
        <a class="button" href="displayBooks.jsp">View Books</a>
    </div>

</body>
</html>
