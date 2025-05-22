package addBooksServlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import DBConnections.DBConnections;

public class RegisterServlet extends HttpServlet {
   protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String role = request.getParameter("role");

    Connection conn = null;
    PreparedStatement checkStmt = null;
    PreparedStatement insertStmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnections.getConnection();

        // Step 1: Check if email already exists
        String checkSql = "SELECT * FROM Users2 WHERE email = ?";
        checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, email);
        rs = checkStmt.executeQuery();

        if (rs.next()) {
            // Email already exists
            request.setAttribute("error", "User already exists with that email.");
        } else {
            // Step 2: Insert new user
            String insertSql = "INSERT INTO Users2 (name, email, password, role) VALUES (?, ?, ?, ?::user_role)";
            insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, name);
            insertStmt.setString(2, email);
            insertStmt.setString(3, password); // For security, hash later
            insertStmt.setString(4, role);

            int rowsInserted = insertStmt.executeUpdate();

            if (rowsInserted > 0) {
                request.setAttribute("message", "Registration successful. Please login.");
            } else {
                request.setAttribute("error", "Registration failed.");
            }
        }
    } catch (SQLException e) {
        request.setAttribute("heading", "Error");
        request.setAttribute("message", "Failed To Register User: " + e.getMessage());
        request.getRequestDispatcher("error2.jsp").forward(request, response);
        return;  // ✅ Stop execution after error forward
    } finally {
        try {
            if (rs != null) rs.close();
            if (checkStmt != null) checkStmt.close();
            if (insertStmt != null) insertStmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Final forward to register.jsp
    RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
    dispatcher.forward(request, response);
}

}
