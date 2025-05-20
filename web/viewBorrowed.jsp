<%@page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DBConnections.DBConnections" %>
<%@ include file="menu.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Books</title>
    <style>
        body {
            font-family: 'Open Sans', sans-serif;
            background-color: #1d2a35;
            color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        .header {
            text-align: center;
            padding: 40px 0;
            background-color: #121e2a;
        }
        .header h1 {
            font-size: 2.5rem;
            color: #f5c776;
        }
        table {
            width: 80%;
            margin: 30px auto;
            border-collapse: collapse;
            background-color: #fff;
            color: #000;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
        }
        th, td {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #ccc;
        }
        th {
            background-color: #1d2a35;
            color: #f5f5f5;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .back-btn {
            text-align: center;
            margin: 30px;
        }
        .back-btn a {
            text-decoration: none;
            padding: 10px 20px;
            background-color: #f5c776;
            color: #1d2a35;
            border-radius: 8px;
            font-weight: bold;
            transition: 0.3s;
        }
        .back-btn a:hover {
            background-color: #fff;
            color: #121e2a;
        }
    </style>
</head>
<body>

<div class="header">
    <h1>Your Borrowed Books</h1>
</div>

<%
    String userID = (String) session.getAttribute("userID");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<!-- Borrowed Books Table -->
<table>
    <tr>
        <th>Book ID</th>
        <th>Title</th>
        <th>Author</th>
        <th>Borrow Date</th>
        <th>Return Date</th>
    </tr>
<%
    boolean hasBorrowed = false;

    try {
        conn = DBConnections.getConnection();
        String sql = "SELECT b.BookID, b.Title, b.Author, bb.BorrowDate, bb.ReturnBookDate " +
                     "FROM BorrowedBooks bb " +
                     "JOIN Books b ON bb.BookID = b.BookID " +
                     "WHERE bb.UserID = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, userID);
        rs = stmt.executeQuery();

        while (rs.next()) {
            hasBorrowed = true;
%>
    <tr>
        <td><%= rs.getInt("BookID") %></td>
        <td><%= rs.getString("Title") %></td>
        <td><%= rs.getString("Author") %></td>
        <td><%= rs.getDate("BorrowDate") %></td>
        <td><%= rs.getDate("ReturnBookDate") %></td>
    </tr>
<%
        }

        if (!hasBorrowed) {
%>
    <tr>
        <td colspan="5">You haven't borrowed any books yet.</td>
    </tr>
<%
        }
        rs.close();
        stmt.close();
%>
</table>

<div class="header">
    <h1>Your Reserved Books</h1>
</div>

<!-- Reserved Books Table -->
<table>
    <tr>
        <th>Book ID</th>
        <th>Title</th>
        <th>Author</th>
        <th>Reservation Date</th>
    </tr>
<%
        boolean hasReserved = false;

        String sql2 = "SELECT b.BookID, b.Title, b.Author, rb.ReservationDate " +
                      "FROM ReservedBooks rb " +
                      "JOIN Books b ON rb.BookID = b.BookID " +
                      "WHERE rb.UserID = ?";
        stmt = conn.prepareStatement(sql2);
        stmt.setString(1, userID);
        rs = stmt.executeQuery();

        while (rs.next()) {
            hasReserved = true;
%>
    <tr>
        <td><%= rs.getInt("BookID") %></td>
        <td><%= rs.getString("Title") %></td>
        <td><%= rs.getString("Author") %></td>
        <td><%= rs.getDate("ReservationDate") %></td>
    </tr>
<%
        }

        if (!hasReserved) {
%>
    <tr>
        <td colspan="4">You haven't reserved any books yet.</td>
    </tr>
<%
        }

    } catch (Exception e) {
        out.println("<p style='color: red; text-align: center;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>
</table>

<div class="back-btn">
    <a href="memberDashboard.jsp">Back to Dashboard</a>
</div>

</body>
</html>
