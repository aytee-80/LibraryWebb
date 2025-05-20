<%@page import="java.sql.*"%>
<%@page import="DBConnections.DBConnections"%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Books List</title>
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
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    conn = DBConnections.getConnection();
                    String sql = "SELECT * FROM Books";
                    stmt = conn.prepareStatement(sql);
                    rs = stmt.executeQuery();

                    boolean hasResults = false;

                    while (rs.next()) {
                        hasResults = true;
                        Blob coverImageBlob = rs.getBlob("image");
                        byte[] coverImageBytes = coverImageBlob != null ? coverImageBlob.getBytes(1, (int) coverImageBlob.length()) : null;
                        String base64Image = coverImageBytes != null ? java.util.Base64.getEncoder().encodeToString(coverImageBytes) : "";
            %>
                <tr>
                    <td><%= rs.getInt("BookID") %></td>
                    <td><%= rs.getString("Title") %></td>
                    <td><%= rs.getString("Author") %></td>
                    <td><%= rs.getString("ISBN") %></td>
                    <td><%= rs.getString("Category") %></td>
                    <td><%= rs.getString("Status") %></td>
                    <td>
                        <% if (!base64Image.isEmpty()) { %>
                            <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Book Cover"/>
                        <% } else { %>
                            <img src="path/to/default-image.jpg" alt="No Cover"/>
                        <% } %>
                    </td>
                </tr>
            <%
                    }

                    if (!hasResults) {
            %>
                <tr><td colspan="7">No books found.</td></tr>
            <%
                    }

                } catch (Exception e) {
                    out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            %>
        </tbody>
    </table>

    <div class="button-container">
        <a href="Delete.jsp">Delete Book</a>
        <a href="update.jsp">Update Book</a>
        <a href="dashboard.jsp">Back to Dashboard</a>
    </div>
</body>
</html>
