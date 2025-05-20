<%@ page session="true" %>
<%
    if (session.getAttribute("role") == null || !"member".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Dashboard</title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700&family=Open+Sans&display=swap');

        /* General Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Open Sans', sans-serif;
            background-color: #1d2a35;
            color: #f5f5f5;
            padding: 0;
        }

        .header {
            text-align: center;
            color: #f5f5f5;
            padding: 50px 0;
            background-color: rgba(0, 0, 0, 0.4);
        }

        .header h1 {
            font-family: 'Merriweather', serif;
            font-size: 3rem;
        }

        h2 {
            text-align: center;
            color: #f5c776;
            font-family: 'Merriweather', serif;
            font-size: 2rem;
            margin: 30px 0 20px;
        }

        ul {
            list-style-type: none;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-top: 30px;
        }

        li {
            margin: 15px 0;
        }

        li a {
            background-color: #121e2a;
            color: #f5c776;
            font-size: 1.2rem;
            padding: 15px 30px;
            border-radius: 8px;
            border: 2px solid #f5c776;
            text-align: center;
            display: inline-block;
            width: 240px;
            transition: all 0.3s ease;
            font-weight: bold;
            text-decoration: none;
        }

        li a:hover {
            background-color: #f5c776;
            color: #1d2a35;
        }

        .footer {
            text-align: center;
            margin: 60px 0 30px;
        }

        .footer a {
            color: #f5c776;
            font-size: 1rem;
        }

        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>Welcome Member, <%= session.getAttribute("name") %>!</h1>
    </div>

    <h2>Dashboard</h2>

    <ul>
        <li><a href="viewAvailableBooks.jsp">View All Books</a></li>
        <li><a href="returnBook.jsp">Return Book</a></li>
        <li><a href="login.jsp">Logout</a></li>
    </ul>
    
    <div class="footer">
        <p><a href="index.html">Back to Home Page</a></p>
    </div>

</body>
</html>
