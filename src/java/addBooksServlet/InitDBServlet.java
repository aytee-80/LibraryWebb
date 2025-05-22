/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package addBooksServlet;

import DBConnections.DBConnections;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Aytee
 */
@WebServlet("/initdb")
public class InitDBServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            DBConnections.initializeDatabase();
            res.getWriter().println("✅ Database initialized!");
        } catch (SQLException e) {
            res.getWriter().println("❌ Error: " + e.getMessage());
        }
    }
}