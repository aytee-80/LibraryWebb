<%@page import="java.sql.*"%>
<%@page import="DBConnections.DBConnections"%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
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
            line-height: 1.6;
            padding-top: 120px;
        }

        header {
            background-color: #121e2a;
            padding: 1rem 2rem;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
            border-bottom: 3px solid #f5c776;
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

        .search-bar {
            display: flex;
            align-items: center;
        }

        .search-bar input[type="text"] {
            padding: 0.5rem;
            border-radius: 5px;
            border: none;
            margin-right: 10px;
        }

        .search-bar select {
            margin-left: 10px;
            padding: 0.5rem;
            border-radius: 5px;
            border: none;
        }

        .search-bar button {
            padding: 0.5rem 1rem;
            background-color: #f5c776;
            color: #1d2a35;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        h1 {
            text-align: center;
            font-size: 2rem;
            margin: 20px 0;
            color: #f5c776;
        }

        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #121e2a;
            color: #f5f5f5;
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border: 1px solid #2c3e50;
        }

        th {
            background-color: #1d2a35;
            color: #f5c776;
        }

        tr:nth-child(even) {
            background-color: #1f2f3c;
        }

        tr:hover {
            background-color: #2c3e50;
        }

        td img {
            width: 80px;
            height: 100px;
            object-fit: cover;
        }

        .button-container {
            text-align: center;
            margin: 30px 0;
        }

        .button-container a {
            display: inline-block;
            margin: 0 10px;
            padding: 10px 20px;
            background-color: #f5c776;
            color: #1d2a35;
            border-radius: 5px;
            font-weight: bold;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .button-container a:hover {
            background-color: #ffe58a;
        }
    </style>
</head>
<body>
<header>
    <div class="logo">Library</div>
    <form method="get" class="search-bar">
        <input type="text" name="search" placeholder="Search by title...">
        <select name="author">
            <option value="">All Authors</option>
            <option value="John Doe">John Doe</option>
            <option value="Michael T. Goodrich">Michael T. Goodrich</option>
            <!-- Add dynamic authors if needed -->
        </select>
        <select name="category">
            <option value="">All Categories</option>
            <option value="Fiction">Fiction</option>
            <option value="Computer Science">Computer Science</option>
            <!-- Add dynamic categories if needed -->
        </select>
        <button type="submit">Search</button>
    </form>
</header>

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

            String search = request.getParameter("search");
            String author = request.getParameter("author");
            String category = request.getParameter("category");

            try {
                conn = DBConnections.getConnection();
                StringBuilder sql = new StringBuilder("SELECT * FROM Books WHERE 1=1");
                if (search != null && !search.trim().isEmpty()) {
                    sql.append(" AND Title LIKE ?");
                }
                if (author != null && !author.trim().isEmpty()) {
                    sql.append(" AND Author = ?");
                }
                if (category != null && !category.trim().isEmpty()) {
                    sql.append(" AND Category = ?");
                }

                stmt = conn.prepareStatement(sql.toString());
                int index = 1;
                if (search != null && !search.trim().isEmpty()) {
                    stmt.setString(index++, "%" + search + "%");
                }
                if (author != null && !author.trim().isEmpty()) {
                    stmt.setString(index++, author);
                }
                if (category != null && !category.trim().isEmpty()) {
                    stmt.setString(index++, category);
                }

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
    <a href="login.jsp">Login to Request or Borrow</a>
    <a href="index.html">Home Page</a>
</div>
</body>
</html>