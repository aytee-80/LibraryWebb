<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Reservation Conflict</title>
    <meta charset="UTF-8">
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
            padding: 60px 20px;
            text-align: center;
        }

        .container {
            max-width: 600px;
            margin: auto;
            background-color: #121e2a;
            border-left: 6px solid #f5c776;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);
        }

        .message {
            font-size: 1.25rem;
            color: #f5c776;
            margin-bottom: 30px;
        }

        .button {
            display: inline-block;
            padding: 12px 25px;
            background-color: #f5c776;
            color: #121e2a;
            text-decoration: none;
            font-weight: bold;
            border-radius: 6px;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #ffdd99;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="message">
            <%= request.getAttribute("error") %>
        </div>
        <a href="reserveBook.jsp?bookId=<%= request.getAttribute("bookId") %>" class="button">Change Reservation Date</a>
    </div>

</body>
</html>
