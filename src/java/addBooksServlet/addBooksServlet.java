package addBooksServlet;

import DBConnections.DBConnections;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig(maxFileSize = 16177215)  // 16MB max file size
public class addBooksServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String isbn = request.getParameter("isbn");
        String category = request.getParameter("category");
        String status = request.getParameter("status");

        InputStream imageStream = null;
        Part imagePart = request.getPart("cover"); // matches the 'name' attribute in your form

        if (imagePart != null) {
            imageStream = imagePart.getInputStream();
        }

        try {
            DBConnections.addBook(title, author, isbn, category, status, imageStream);
            response.sendRedirect("displayBooks.jsp"); // Redirect after successful insert
        } catch (IOException | SQLException e) {
            request.setAttribute("heading", "Error");
            request.setAttribute("message", "Failed to add Book: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
