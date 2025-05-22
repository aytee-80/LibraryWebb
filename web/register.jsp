<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library Registration</title>
    
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

        .register-container {
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

        input[type="text"], input[type="password"], select {
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

        .message {
            text-align: center;
            margin-top: 20px;
        }

        .message .success {
            color: green;
        }

        .message .error {
            color: red;
        }
    </style>
</head>
<body>

<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String role = request.getParameter("role");
    StringBuilder errorBuilder = new StringBuilder();

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if (name == null || !name.matches("[A-Za-z ]{2,}")) {
            errorBuilder.append("Name must contain only letters and be at least 2 characters long.<br>");
        }

       if (email == null || !email.contains("@") || 
    !(email.endsWith(".com") || email.endsWith("gmail.co.za"))) {
    errorBuilder.append("Email must contain '@' and end with either '.com' or 'gmail.co.za'.<br>");
}
        if (password == null || password.length() < 8) {
            errorBuilder.append("Password must be at least 8 characters long.<br>");
        }

        if (role == null || !(role.equals("member") || role.equals("librarian"))) {
            errorBuilder.append("Invalid role selected.<br>");
        }

        if (errorBuilder.length() > 0) {
            request.setAttribute("error", errorBuilder.toString());
        }
    }
%>

<div class="register-container">
    <h2>Register for a New Account</h2>

    <form action="RegisterServlet.do" method="post">
        <label for="name">Name:</label>
        <input type="text" name="name" id="name" value="<%= name != null ? name : "" %>" required>

        <label for="email">Email:</label>
        <input type="text" name="email" id="email" value="<%= email != null ? email : "" %>" required>

        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required>

        <label for="role">Role:</label>
        <select name="role" id="role" required>
            <option value="Member" <%= "member".equals(role) ? "selected" : "" %>>Member</option>
            <option value="Librarian" <%= "librarian".equals(role) ? "selected" : "" %>>Librarian</option>
        </select>

        <input type="submit" value="Register">
    </form>

    <div class="message">
        <% if (request.getAttribute("message") != null) { %>
            <p class="success"><%= request.getAttribute("message") %></p>
        <% } else if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
    </div>

    <br>
    <p>Already have an account? <a href="login.jsp">Login here</a></p>
</div>

</body>
</html>
