/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package connect;

import DBConnections.DBConnections;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Aytee
 */
@WebServlet(name = "connect", urlPatterns = {"/connect.do"})
public class connect extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        String connn = " ";
        Connection conn = null;
        try {
            conn = DBConnections.getConnection();
        } catch (SQLException ex) {
            System.out.print(ex);
        }
        if (conn != null) {
             connn = "Connected to database successfully!";
        }
        else {
            connn = "Not connected";
        }
        
        session.setAttribute("connn" , connn);
        
        request.getRequestDispatcher("result.jsp").forward(request, response);
        

        
        
        
    }
}

    