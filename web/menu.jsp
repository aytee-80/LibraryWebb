<%
    String role = null;
    if (session != null && session.getAttribute("role") != null) {
        role = (String) session.getAttribute("role");
    }
%>

<div style="background-color: #2c3e50; padding: 10px;">
    <a href="index.html" style="color: white; margin-right: 15px;">Home</a>

    <% if ("librarian".equalsIgnoreCase(role)) { %>
        <a href="librarianDashboard.jsp" style="color: white; margin-right: 15px;">Dashboard</a>
        <a href="addBook.jsp" style="color: white; margin-right: 15px;">Add Book</a>
        <a href="update.jsp" style="color: white; margin-right: 15px;">Update Book</a>
        <a href="Delete.jsp" style="color: white; margin-right: 15px;">Delete Book</a>
        <a href="displayBooks.jsp" style="color: white; margin-right: 15px;">View Books</a>
        <a href="report1.jsp" style="color: white; margin-right: 15px;">Report 1</a>
        <a href="report2.jsp" style="color: white; margin-right: 15px;">Report 2</a>
    <% } else if ("member".equalsIgnoreCase(role)) { %>
        <a href="memberDashboard.jsp" style="color: white; margin-right: 15px;">Dashboard</a>
        <a href="viewAvailableBooks.jsp" style="color: white; margin-right: 15px;">Browse Books</a>
    <% } else { %>
        <!-- Public menu only -->
        <a href="login.jsp" style="color: white; margin-right: 15px;">Login</a>
        <a href="register.jsp" style="color: white;">Register</a>
    <% } %>
</div>
