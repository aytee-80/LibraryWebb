<%@page import="java.sql.*"%>
<%@page import="DBConnections.DBConnections"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Base64"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Borrowed Books</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #1d2a35;
            color: #f5f5f5;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #f5c776;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #121e2a;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #2c3e50;
            padding: 12px;
            text-align: center;
        }

        th {
            background-color: #2c3e50;
            color: #f5c776;
        }

        tr:nth-child(even) {
            background-color: #1f2f3d;
        }

        .return-btn {
            padding: 8px 16px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .return-btn:hover {
            background-color: #c82333;
        }

        .msg {
            text-align: center;
            font-size: 1.2em;
            color: lightgreen;
            margin-top: 10px;
        }

        .button-container {
            margin-top: 20px;
            text-align: center;
        }

        .button-container a {
            padding: 10px 20px;
            background-color: #f5c776;
            color: #121e2a;
            text-decoration: none;
            border-radius: 5px;
        }

        img {
            width: 80px;
            height: 100px;
            object-fit: cover;
        }
    </style>
</head>
<body>

<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    Integer userID = (Integer) session.getAttribute("userID");
    String message = "";

    // Check for return submission
    String returnBookId = request.getParameter("returnBookId");
    if (returnBookId != null) {
        try {
            conn = DBConnections.getConnection();

            // Step 1: Update the Books table
            stmt = conn.prepareStatement("UPDATE Books SET Status = 'Available', borrowed_by_member_id = NULL WHERE BookID = ?");
            stmt.setInt(1, Integer.parseInt(returnBookId));
            int updated = stmt.executeUpdate();
            stmt.close();

            // Step 2: Delete from BorrowedBooks table
            stmt = conn.prepareStatement("DELETE FROM BorrowedBooks WHERE BookID = ? AND userid = ?");
            stmt.setInt(1, Integer.parseInt(returnBookId));
            stmt.setInt(2, userID);
            stmt.executeUpdate();
            stmt.close();

            message = "Book returned successfully!";
        } catch (Exception e) {
            message = "Error while returning book: " + e.getMessage();
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
%>

<h1>Your Borrowed Books</h1>

<% if (!message.isEmpty()) { %>
    <div class="msg"><%= message %></div>
<% } %>

<table>
    <thead>
        <tr>
            <th>BookID</th>
            <th>Title</th>
            <th>Author</th>
            <th>ISBN</th>
            <th>Category</th>
            <th>Cover</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
    <%
        try {
            conn = DBConnections.getConnection();
            String query = "SELECT * FROM Books WHERE userid = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, userID);
            rs = stmt.executeQuery();

            while (rs.next()) {
                int bookId = rs.getInt("BookID");
                String title = rs.getString("Title");
                String author = rs.getString("Author");
                String isbn = rs.getString("ISBN");
                String category = rs.getString("Category");
                byte[] imageBytes = rs.getBytes("image");
                String base64Image = (imageBytes != null) ? Base64.getEncoder().encodeToString(imageBytes) : "";
    %>
        <tr>
            <td><%= bookId %></td>
            <td><%= title %></td>
            <td><%= author %></td>
            <td><%= isbn %></td>
            <td><%= category %></td>
            <td>
                <% if (!base64Image.isEmpty()) { %>
                    <img src="data:image/jpeg;base64,<%= base64Image %>" />
                <% } else { %>
                    No Image
                <% } %>
            </td>
            <td>
                <form method="post" action="returnBook.jsp">
                    <input type="hidden" name="returnBookId" value="<%= bookId %>">
                    <button type="submit" class="return-btn">Return</button>
                </form>
            </td>
        </tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    %>
    </tbody>
</table>

<div class="button-container">
    <a href="dashboard.jsp">Back to Dashboard</a>
</div>

</body>
</html>
