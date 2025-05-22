package addBooksServlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import DBConnections.DBConnections;

public class BookActionsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        HttpSession session = request.getSession();
        int userID = (Integer) session.getAttribute("userID");

        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            conn = DBConnections.getConnection();

            // Get current status
            String sql = "SELECT Status FROM Books WHERE BookID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String status = rs.getString("Status");

                if ("Available".equalsIgnoreCase(status)) {
  
                    request.getRequestDispatcher("borrowBook.jsp").forward(request, response);
                } else if ("Borrowed".equalsIgnoreCase(status)) {
                    
                    
                    session.setAttribute("userID", userID);
                    
                     request.getRequestDispatcher("reserveBook.jsp").forward(request, response);
                } else {
                    request.setAttribute("message", "Book is already reserved.");
                    request.setAttribute("heading", "Unavailable");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                    return;
                }

                int updated = stmt.executeUpdate();
                if (updated > 0) {
                    request.setAttribute("message", "Book action successful.");
                } else {
                    request.setAttribute("message", "Failed to update book.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                    return;
                }
            }

            

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
