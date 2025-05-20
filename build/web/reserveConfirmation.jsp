<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Message</title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700&family=Open+Sans&display=swap');

        body {
            font-family: 'Open Sans', sans-serif;
            background-color: #1d2a35;
            color: #f5f5f5;
            margin: 0;
            padding: 0;
            padding-top: 80px;
        }

        h2 {
            font-family: 'Merriweather', serif;
            text-align: center;
            color: #f5c776;
            margin-top: 40px;
            margin-bottom: 20px;
            font-size: 2rem;
        }

        p {
            text-align: center;
            font-size: 1.2rem;
        }

        a {
            color: #f5c776;
            text-decoration: none;
            font-weight: bold;
            padding: 8px 16px;
            border: 2px solid #f5c776;
            border-radius: 6px;
            transition: background-color 0.3s ease;
        }

        a:hover {
            background-color: #f5c776;
            color: #1d2a35;
        }
    </style>
</head>
<body>

    <h2><%= request.getAttribute("message") %></h2>
    <p><a href="viewAvailableBooks.jsp">Back to Books</a></p>

</body>
</html>
