package addBooksServlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.time.LocalDate;
import DBConnections.DBConnections;


public class BookActionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
         HttpSession s = request.getSession();
        
        String action = request.getParameter("action");
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int userID = (Integer) s.getAttribute("userID");
        String email = (String) s.getAttribute("email");
        String contact = request.getParameter("contact");
        String returnDate2 = request.getParameter("returnDate");
        
                Connection conn = null;
         
        try {
            
           conn = DBConnections.getConnection();

            if ("borrow".equalsIgnoreCase(action)) {
                
                java.sql.Date sqlReturnDate = java.sql.Date.valueOf(returnDate2); // ✅ converted to proper Date object
                 java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());

               

                // Insert into BorrowedBooks
                String sql = "INSERT INTO BorrowedBooks (BookID, UserEmail, ContactNumber , returnbookdate,userID ,BorrowDate) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, bookId);
                    stmt.setString(2, email);
                    stmt.setString(3, contact);
                    stmt.setDate(4, sqlReturnDate);
                    stmt.setInt(5, userID);
                    stmt.setDate(6, currentDate);
                    stmt.executeUpdate();
                }
                
                // Update book status to Borrowed
                try (PreparedStatement update = conn.prepareStatement("UPDATE Books SET Status = 'Borrowed', borrowed_by_member_id = ? WHERE BookID = ?") ) {
                    update.setInt(1, userID);
                    update.setInt(2, bookId);
                    update.executeUpdate();
                }

                request.setAttribute("message", "✅ Book borrowed successfully. Return by: " + returnDate2);
                request.getRequestDispatcher("borrowConfirmation.jsp").forward(request, response);
            }

            else if ("reserve".equalsIgnoreCase(action)) {
                String reservationDate = request.getParameter("reservationDate");
                LocalDate reserveDate = LocalDate.parse(reservationDate);
                LocalDate expiryDate = reserveDate.plusDays(3); // Reservation valid for 3 days
                LocalDate bookReturnDate = null;
                // Check if return date of the book allows reservation
                String checkReturnSQL = "SELECT returnbookdate FROM BorrowedBooks WHERE BookID = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkReturnSQL)) {
                    checkStmt.setInt(1, bookId);
                    ResultSet rs = checkStmt.executeQuery();
                   
                    if (rs.next()) {
                         bookReturnDate = rs.getDate("returnbookdate").toLocalDate(); // ✅ no conflict

                        if (reserveDate.isBefore(bookReturnDate)) {
                            request.setAttribute("error", "⚠️ The book won't be available on " + reservationDate +
                                    ". It will be returned on: " + bookReturnDate + ".");
                            request.setAttribute("bookId", bookId);
                            request.getRequestDispatcher("reservationDateError.jsp").forward(request, response);
                            return;
                        }
                    }
                }

                // Insert into ReservedBooks
                String insertSql = "INSERT INTO ReservedBooks (BookID, UserEmail, ReservationDate, ExpiryDate , userID ) VALUES (?, ?, ?, ? ,?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                    stmt.setInt(1, bookId);
                    stmt.setString(2, email);
                    stmt.setDate(3, Date.valueOf(bookReturnDate));
                    stmt.setDate(4, Date.valueOf(expiryDate));
                    stmt.setInt(5, userID);
                    stmt.executeUpdate();
                }

                // Update book status to Reserved
                try (PreparedStatement update = conn.prepareStatement("UPDATE Books SET Status = 'Reserved', borrowed_by_member_id = ? WHERE BookID = ?")) {
                    update.setInt(1, userID);
                    update.setInt(2, bookId);
                    update.executeUpdate();
                }

                request.setAttribute("message", "✅ Book reserved successfully. Expires on " + expiryDate + ".");
                request.getRequestDispatcher("reserveConfirmation.jsp").forward(request, response);
            }

        } catch (IOException | SQLException | ServletException e) {
            request.setAttribute("message", "❌ Error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }
    }
}
