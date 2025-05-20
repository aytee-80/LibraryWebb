package addBooksServlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import DBConnections.DBConnections;

public class BorrowedBooksServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        HttpSession session = request.getSession();
        int userID = (Integer) session.getAttribute("userID");

        try {
            conn = DBConnections.getConnection();
            stmt = conn.prepareStatement("SELECT * FROM BorrowedBooks WHERE borrowed_by_member_id = ?");
            stmt.setInt(1, userID);
            rs = stmt.executeQuery();
            
            request.setAttribute("borrowedBooks", rs);
            request.getRequestDispatcher("borrowedBooks.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
}
