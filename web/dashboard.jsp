<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    String name = (String) session.getAttribute("name");

    if (role == null || name == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
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

        /* New CSS for Reports Links */
        .reports-links {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 30px 0;
        }

        .reports-links a {
            background-color: #121e2a;
            color: #f5c776;
            padding: 12px 20px;
            border-radius: 8px;
            border: 2px solid #f5c776;
            font-size: 1.1rem;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .reports-links a:hover {
            background-color: #f5c776;
            color: #1d2a35;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>Welcome <%= role.substring(0, 1).toUpperCase() + role.substring(1) %>, <%= name %>!</h1>

        <% if ("librarian".equalsIgnoreCase(role)) { %>
            <div class="reports-links">
                <a href="report1.jsp">Report 1</a>
                <a href="report_available.jsp">Report 2</a>
                <a href="report_issued.jsp">Report 3</a>
                <a href="report_reserved.jsp">Report 4</a>
                <a href="report_summary.jsp">Summary</a>
            </div>
        <% } %>
    </div>

    <h2>Dashboard</h2>

    <ul>
        <% if ("librarian".equalsIgnoreCase(role)) { %>
            <li><a href="addBook.jsp">Add Book</a></li>
            <li><a href="displayBooks.jsp">View / Update / Delete Books</a></li>
        <% } else if ("member".equalsIgnoreCase(role)) { %>
            <li><a href="viewAvailableBooks.jsp">View All Books</a></li>
            <li><a href="returnBook.jsp">Return Book</a></li>
        <% } %>
        <li><a href="login.jsp">Logout</a></li>
    </ul>

    <div class="footer">
        <p><a href="index.html">Back to Home Page</a></p>
    </div>

</body>
</html>
