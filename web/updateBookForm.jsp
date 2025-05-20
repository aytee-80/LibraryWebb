<%@ page import="java.sql.*" %>
<%@ page import="DBConnections.DBConnections" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String bookId = request.getParameter("id");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnections.getConnection();
        String query = "SELECT * FROM Books WHERE BookID = ?";
        stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(bookId));
        rs = stmt.executeQuery();

        if (rs.next()) {
            request.setAttribute("bookId", bookId);
            request.setAttribute("title", rs.getString("Title"));
            request.setAttribute("author", rs.getString("Author"));
            request.setAttribute("isbn", rs.getString("ISBN"));
            request.setAttribute("category", rs.getString("Category"));
            request.setAttribute("status", rs.getString("Status"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
        try { if (conn != null) conn.close(); } catch (SQLException e) {}
    }

    String status = (String) request.getAttribute("status");
    String category = (String) request.getAttribute("category");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Book</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700&family=Open+Sans&display=swap');
        body {
            font-family: 'Open Sans', sans-serif;
            background-color: #1d2a35;
            color: #f5f5f5;
            margin: 0;
            padding-top: 80px;
        }

        h1 {
            font-family: 'Merriweather', serif;
            text-align: center;
            color: #f5c776;
            margin-bottom: 30px;
        }

        form {
            max-width: 600px;
            margin: auto;
            background-color: #121e2a;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }

        label {
            display: block;
            font-size: 1.1rem;
            color: #f5f5f5;
            margin-bottom: 6px;
        }

        input[type="text"], select {
            width: 100%;
            padding: 10px;
            font-size: 1rem;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f5f5f5;
            color: #333;
        }

        .error {
            color: #ff6f61;
            font-size: 0.95rem;
            margin-top: -14px;
            margin-bottom: 12px;
            display: none;
        }

        button {
            width: 100%;
            padding: 12px;
            font-size: 1.2rem;
            background-color: #f5c776;
            color: #1d2a35;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #ffdb70;
        }

        a {
            display: block;
            text-align: center;
            margin-top: 2rem;
            color: #f5c776;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            form {
                width: 90%;
            }

            h1 {
                font-size: 1.5rem;
            }
        }
    </style>

    <script>
        function validateUpdateForm() {
            let isValid = true;
            document.querySelectorAll(".error").forEach(e => e.style.display = "none");

            const author = document.getElementById("author").value.trim();
            const isbn = document.getElementById("isbn").value.trim();

            const authorPattern = /^[A-Za-z\s]+$/;
            const isbnPattern = /^[0-9]{8,11}$/;

            if (!authorPattern.test(author)) {
                document.getElementById("authorError").style.display = "block";
                isValid = false;
            }

            if (!isbnPattern.test(isbn)) {
                document.getElementById("isbnError").style.display = "block";
                isValid = false;
            }

            return isValid;
        }
    </script>
</head>
<body>

<h1>Update Book Details</h1>

<form action="UpdateBookServlet.do" method="post" onsubmit="return validateUpdateForm();">
    <input type="hidden" name="bookId" value="<%= request.getAttribute("bookId") %>"/>

    <label>Title:</label>
    <input type="text" name="title" value="<%= request.getAttribute("title") %>" required>

    <label>Author:</label>
    <input type="text" id="author" name="author" value="<%= request.getAttribute("author") %>" required>
    <div class="error" id="authorError">Author name must only contain letters and spaces.</div>

    <label>ISBN:</label>
    <input type="text" id="isbn" name="isbn" value="<%= request.getAttribute("isbn") %>" required>
    <div class="error" id="isbnError">ISBN must be a number with 8 to 11 digits.</div>

    <label>Category:</label>
    <select id="category" name="category" required>
        <option value="" disabled>Choose category</option>
        <option value="Computer Science" <%= "Computer Science".equalsIgnoreCase(category) ? "selected" : "" %>>Computer Science</option>
        <option value="Engineering" <%= "Engineering".equalsIgnoreCase(category) ? "selected" : "" %>>Engineering</option>
        <option value="Mathematics" <%= "Mathematics".equalsIgnoreCase(category) ? "selected" : "" %>>Mathematics</option>
        <option value="Literature" <%= "Literature".equalsIgnoreCase(category) ? "selected" : "" %>>Literature</option>
        <option value="History" <%= "History".equalsIgnoreCase(category) ? "selected" : "" %>>History</option>
        <option value="Science" <%= "Science".equalsIgnoreCase(category) ? "selected" : "" %>>Science</option>
        <option value="Fantasy" <%= "Fantasy".equalsIgnoreCase(category) ? "selected" : "" %>>Fantasy</option>
        <option value="Horror" <%= "Horror".equalsIgnoreCase(category) ? "selected" : "" %>>Horror</option>
        <option value="Romance" <%= "Romance".equalsIgnoreCase(category) ? "selected" : "" %>>Romance</option>
        <option value="Thriller" <%= "Thriller".equalsIgnoreCase(category) ? "selected" : "" %>>Thriller</option>
    </select>

    <label>Status:</label>
    <select name="status" required>
        <option value="">--Please Select--</option>
        <option value="Available" <%= "Available".equalsIgnoreCase(status) ? "selected" : "" %>>Available</option>
        <option value="Borrowed" <%= "Borrowed".equalsIgnoreCase(status) ? "selected" : "" %>>Borrowed</option>
        <option value="Reserved" <%= "Reserved".equalsIgnoreCase(status) ? "selected" : "" %>>Reserved</option>
    </select>

    <button type="submit">Update Book</button>
</form>

<a href="dashboard.jsp">Back to Dashboard</a>

</body>
</html>
