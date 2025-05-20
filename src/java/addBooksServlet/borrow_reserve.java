/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package addBooksServlet;

import DBConnections.DBConnections;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Aytee
 */
public class borrow_reserve extends HttpServlet {

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession s = request.getSession();
        
        String action = request.getParameter("action");
        int bookId =(int) s.getAttribute("bookId");
        int userId = (int)s.getAttribute("userID");
        String email = request.getParameter("email");

        Connection conn = null;

        try {
            conn = DBConnections.getConnection();

            if ("borrow".equalsIgnoreCase(action)) {
                String contact = request.getParameter("contact");
                String returnDate = request.getParameter("returnDate");

                // Insert into BorrowedBooks
                String sql = "INSERT INTO BorrowedBooks (BookID, UserEmail, ContactNumber, ReturnDate) VALUES (?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, bookId);
                    stmt.setString(2, email);
                    stmt.setString(3, contact);
                    stmt.setDate(4, Date.valueOf(returnDate));
                    stmt.executeUpdate();
                }

                // Update book status to Borrowed
                try (PreparedStatement update = conn.prepareStatement("UPDATE Books SET Status='Borrowed' WHERE BookID=?")) {
                    update.setInt(1, bookId);
                    update.executeUpdate();
                }

                request.setAttribute("message", "✅ Book borrowed successfully. Return by: " + returnDate);
                request.getRequestDispatcher("borrowConfirmation.jsp").forward(request, response);
            }

            else if ("reserve".equalsIgnoreCase(action)) {
                String reservationDate = request.getParameter("reservationDate");
                LocalDate reserveDate = LocalDate.parse(reservationDate);
                LocalDate expiryDate = reserveDate.plusDays(3); // Reservation valid for 3 days

                // Check if return date of the book allows reservation
                String checkReturnSQL = "SELECT ReturnDate FROM BorrowedBooks WHERE BookID = ?";
                try (PreparedStatement checkStmt = conn.prepareStatement(checkReturnSQL)) {
                    checkStmt.setInt(1, bookId);
                    ResultSet rs = checkStmt.executeQuery();
                    if (rs.next()) {
                        LocalDate returnDate = rs.getDate("ReturnDate").toLocalDate();
                        if (reserveDate.isBefore(returnDate)) {
                            request.setAttribute("error", "⚠️ The book won't be available on " + reservationDate +
                                    ". It will be returned on: " + returnDate + ".");
                            request.setAttribute("bookId", bookId);
                            request.getRequestDispatcher("reservationDateError.jsp").forward(request, response);
                            return;
                        }
                    }
                }

                // Insert into ReservedBooks
                String insertSql = "INSERT INTO ReservedBooks (BookID, UserEmail, ReservationDate, ExpiryDate) VALUES (?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                    stmt.setInt(1, bookId);
                    stmt.setString(2, email);
                    stmt.setDate(3, Date.valueOf(reserveDate));
                    stmt.setDate(4, Date.valueOf(expiryDate));
                    stmt.executeUpdate();
                }

                // Update book status to Reserved
                try (PreparedStatement update = conn.prepareStatement("UPDATE Books SET Status='Reserved' WHERE BookID=?")) {
                    update.setInt(1, bookId);
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
