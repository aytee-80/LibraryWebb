<%@page import="java.sql.*"%>
<%@page import="DBConnections.DBConnections"%>
<%@page import="java.util.Base64"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>View Books</title>
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
            padding: 40px 20px;
        }

        h1 {
            text-align: center;
            font-family: 'Merriweather', serif;
            font-size: 2.5rem;
            color: #f5c776;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #121e2a;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.5);
        }

        th, td {
            padding: 14px 10px;
            border: 1px solid #2c3e50;
            text-align: center;
        }

        th {
            background-color: #2c3e50;
            color: #f5c776;
            font-size: 1rem;
        }

        tr:nth-child(even) {
            background-color: #1f2f3d;
        }

        tr:hover {
            background-color: #2d3e50;
        }

        td img {
            width: 80px;
            height: 100px;
            object-fit: cover;
            border-radius: 5px;
            border: 1px solid #555;
        }

        .button-container {
            margin-top: 30px;
            text-align: center;
        }

        .button-container a {
            margin: 8px 12px;
            padding: 12px 24px;
            background-color: #f5c776;
            color: #121e2a;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .button-container a:hover {
            background-color: #ffdd99;
        }

        a {
            text-decoration: none;
        }

        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            color: white;
            font-weight: bold;
        }

        .available-btn {
            background-color: #28a745;
        }

        .borrowed-btn {
            background-color: #ffc107;
        }

        .reserve-btn {
            background-color: #17a2b8;
        }

        .disabled-btn {
            background-color: #6c757d;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <h1>Books List</h1>
    <table>
        <thead>
            <tr>
                <th>Book ID</th>
                <th>Title</th>
                <th>Author</th>
                <th>ISBN</th>
                <th>Category</th>
                <th>Status</th>
                <th>Cover</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            Integer userID = (Integer) session.getAttribute("userID");

            try {
                conn = DBConnections.getConnection();
                stmt = conn.prepareStatement("SELECT * FROM Books");
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int bookId = rs.getInt("BookID");
                    String title = rs.getString("Title");
                    String author = rs.getString("Author");
                    String isbn = rs.getString("ISBN");
                    String category = rs.getString("Category");
                    String status = rs.getString("Status");
                    int borrowedBy = rs.getInt("borrowed_by_member_id");

                    byte[] imageBytes = rs.getBytes("image");
                    String base64Image = "";
                    if (imageBytes != null) {
                        base64Image = Base64.getEncoder().encodeToString(imageBytes);
                    }
        %>
            <tr>
                <td><%= bookId %></td>
                <td><%= title %></td>
                <td><%= author %></td>
                <td><%= isbn %></td>
                <td><%= category %></td>
                <td><%= status %></td>
                <td>
                    <% if (!base64Image.isEmpty()) { %>
                        <img src="data:image/jpeg;base64,<%= base64Image %>" width="80" height="100"/>
                    <% } else { %>
                        No Image
                    <% } %>
                </td>
                <td>
                    <%
                        if ("Available".equals(status)) {
                    %>
                        <form action="BookActionsServlet.do" method="post">
                            <input type="hidden" name="bookId" value="<%= bookId %>">
                            <button type="submit" class="action-btn available-btn">Request</button>
                        </form>
                    <%
                        } else if ("Borrowed".equals(status)) {
                            if (borrowedBy == userID) {
                    %>
                                <button class="action-btn borrowed-btn disabled-btn" disabled>You borrowed this book</button>
                    <%
                            } else {
                    %>
                                <form action="BookActionsServlet.do" method="post">
                                    <input type="hidden" name="bookId" value="<%= bookId %>">
                                    <button type="submit" class="action-btn borrowed-btn">Reserve</button>
                                </form>
                    <%
                            }
                        } else if ("Reserved".equals(status)) {
                            if (borrowedBy == userID) {
                    %>
                                <button class="action-btn reserve-btn disabled-btn" disabled>You reserved this book</button>
                    <%
                            } else {
                    %>
                                <button class="action-btn reserve-btn disabled-btn" disabled>Reserved</button>
                    <%
                            }
                        }
                    %>
                </td>
            </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
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
