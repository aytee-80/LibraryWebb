package addBooksServlet;

import DBConnections.DBConnections;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UpdateBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("bookId"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String isbn = request.getParameter("isbn");
        String category = request.getParameter("category");
        String status = request.getParameter("status");

        try {
            DBConnections.updateBook(id, title, author, isbn, category, status);
            response.sendRedirect("displayBooks.jsp");  // Redirect to the page that displays books
        } catch (IOException | SQLException e) {
           
               request.setAttribute("message", "Failed to update Book : " + e.getMessage());
             request.setAttribute("heading", "UPDATE");
             request.getRequestDispatcher("error.jsp").forward(request, response);
            ;
        }
    }
}
