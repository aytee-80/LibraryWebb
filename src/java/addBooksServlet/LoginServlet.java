package addBooksServlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import DBConnections.DBConnections;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnections.getConnection();
            String sql = "SELECT * FROM Users2 WHERE Email = ? AND Password = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);

            rs = stmt.executeQuery();

            if (rs.next()) {
                // User found, store user data in session
                HttpSession session = request.getSession();
                session.setAttribute("userID", rs.getInt("UserID"));
                
                session.setAttribute("name", rs.getString("Name"));
                session.setAttribute("role", rs.getString("Role"));
                session.setAttribute("email", email);
                // Redirect based on role
                /*String role = rs.getString("Role");
                if ("librarian".equalsIgnoreCase(role)) {
                    response.sendRedirect("librarianDashboard.jsp");
                } else {
                    response.sendRedirect("memberDashboard.jsp");
                }*/
                response.sendRedirect("dashboard.jsp");
                

            } else {
                request.setAttribute("error", "Invalid email or password.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
                dispatcher.forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
