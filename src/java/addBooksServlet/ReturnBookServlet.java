package addBooksServlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import DBConnections.DBConnections;

public class ReturnBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Connection conn = null;
        PreparedStatement stmt = null;
        HttpSession session = request.getSession();
        int userID = (Integer) session.getAttribute("userID");

        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            conn = DBConnections.getConnection();

            // Delete the borrowed book entry
            stmt = conn.prepareStatement("DELETE FROM BorrowedBooks WHERE BookID = ? AND borrowed_by_member_id = ?");
            stmt.setInt(1, bookId);
            stmt.setInt(2, userID);
            int deleted = stmt.executeUpdate();

            if (deleted > 0) {
                // Update the book's status back to Available
                stmt = conn.prepareStatement("UPDATE Books SET Status = 'Available', borrowed_by_member_id = NULL WHERE BookID = ?");
                stmt.setInt(1, bookId);
                stmt.executeUpdate();

                request.setAttribute("message", "Successfully returned the book.");
            } else {
                request.setAttribute("message", "Failed to return the book.");
            }

            request.getRequestDispatcher("returnConfirmation.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
}
