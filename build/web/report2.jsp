<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="java.sql.*"%>
<%@page import="DBConnections.DBConnections"%>
<%@ include file="menu.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report 2 - Issued, Available, and Reserved Books</title>
    <style>
        body {
            background-color: #f4f7fc;
            font-family: Arial, sans-serif;
            padding: 30px;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-top: 40px;
        }

        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background: #fff;
            border-radius: 6px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #2c3e50;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #eaf6ff;
        }
    </style>
</head>
<body>

<!-- Issued Books -->
<h2>Issued Books</h2>
<table>
    <tr>
        <th>Title</th>
        <th>Borrowed By</th>
        <th>Email</th>
        <th>Contact</th>
        <th>Borrow Date</th>
        <th>Return Date</th>
    </tr>
    <%
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnections.getConnection();
            String sql = "SELECT b.Title, u.Name AS BorrowedBy, u.Email, bb.ContactNumber, bb.BorrowDate, bb.ReturnDate " +
                         "FROM BORROWEDBOOKS bb " +
                         "JOIN BOOKS b ON bb.BookID = b.BookID " +
                         "JOIN USERS u ON bb.UserEmail = u.Email " +
                         "WHERE b.Status = 'Borrowed'";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            boolean found = false;
            while (rs.next()) {
                found = true;
    %>
        <tr>
            <td><%= rs.getString("Title") %></td>
            <td><%= rs.getString("BorrowedBy") %></td>
            <td><%= rs.getString("Email") %></td>
            <td><%= rs.getString("ContactNumber") %></td>
            <td><%= rs.getDate("BorrowDate") %></td>
            <td><%= rs.getDate("ReturnDate") %></td>
        </tr>
    <%
            }
            if (!found) {
    %>
        <tr><td colspan="6">No issued books found.</td></tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
        }
    %>
</table>

<!-- Available Books -->
<h2>Available Books</h2>
<table>
    <tr>
        <th>Book ID</th>
        <th>Title</th>
        <th>Author</th>
        <th>Category</th>
        <th>Publisher</th>
    </tr>
    <%
        try {
            String sql2 = "SELECT * FROM BOOKS WHERE Status = 'Available'";
            stmt = conn.prepareStatement(sql2);
            rs = stmt.executeQuery();

            boolean found = false;
            while (rs.next()) {
                found = true;
    %>
        <tr>
            <td><%= rs.getInt("BookID") %></td>
            <td><%= rs.getString("Title") %></td>
            <td><%= rs.getString("Author") %></td>
            <td><%= rs.getString("Category") %></td>
            <td><%= rs.getString("Publisher") %></td>
        </tr>
    <%
            }
            if (!found) {
    %>
        <tr><td colspan="5">No available books at the moment.</td></tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
        }
    %>
</table>

<!-- Reserved Books -->
<h2>Reserved Books</h2>
<table>
    <tr>
        <th>Title</th>
        <th>Reserved By</th>
        <th>Email</th>
        <th>Reservation Date</th>
    </tr>
    <%
        try {
            String sql3 = "SELECT b.Title, u.Name, u.Email, rb.ReservationDate " +
                          "FROM ReservedBooks rb " +
                          "JOIN Books b ON rb.BookID = b.BookID " +
                          "JOIN Users u ON rb.UserEmail = u.Email";
            stmt = conn.prepareStatement(sql3);
            rs = stmt.executeQuery();

            boolean found = false;
            while (rs.next()) {
                found = true;
    %>
        <tr>
            <td><%= rs.getString("Title") %></td>
            <td><%= rs.getString("Name") %></td>
            <td><%= rs.getString("Email") %></td>
            <td><%= rs.getDate("ReservationDate") %></td>
        </tr>
    <%
            }
            if (!found) {
    %>
        <tr><td colspan="4">No reserved books found.</td></tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    %>
</table>

</body>
</html>
