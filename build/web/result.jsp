<%-- 
    Document   : result
    Created on : Apr 8, 2025, 3:03:40 PM
    Author     : Aytee
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Database Connect</h1>
        
        <%
            String display =(String)session.getAttribute("connn");
            
        %>
        
        
        <p>
            <%=display%>
        </p>
    </body>
</html>
