package addBooksServlet;

import DBConnections.DBConnections;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DeleteBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        try {
            DBConnections.deleteBook(id);
            response.sendRedirect("displayBooks.jsp");  // Redirect to the page that displays books
        } catch (IOException | SQLException e) {
          
             request.setAttribute("message", "Failed to Delete Book : " + e.getMessage());
             request.setAttribute("heading", "Delete");
             request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
