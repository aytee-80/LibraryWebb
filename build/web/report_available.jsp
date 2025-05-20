<%@page import="java.sql.*"%>
<%@page import="DBConnections.DBConnections"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Available Books Report</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Merriweather :wght@400;700&family=Open+Sans&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background-color: #1d2a35;
            font-family: 'Open Sans', sans-serif;
            color: #f5f5f5;
            padding: 40px;
        }

        h2 {
            text-align: center;
            color: #f5c776;
            font-family: 'Merriweather', serif;
            font-size: 2rem;
            margin-bottom: 30px;
        }

        .filter-form {
            width: 80%;
            margin: 0 auto 30px;
            background-color: #121e2a;
            padding: 20px;
            border-radius: 6px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
        }

        .filter-form label {
            color: #f5c776;
        }

        .filter-form input,
        .filter-form select,
        .filter-form button {
            padding: 10px;
            border: 1px solid #555;
            background-color: #f5f5f5;
            color: #1d2a35;
            border-radius: 5px;
            min-width: 180px;
            font-size: 14px;
        }

        .filter-form button {
            background-color: #f5c776;
            border: none;
            font-weight: bold;
            cursor: pointer;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 80%;
            margin: 0 auto;
            border-collapse: separate;
            border-spacing: 0;
            background-color: #121e2a;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            border-radius: 6px;
            overflow: hidden;
        }

        th, td {
            padding: 12px 16px;
            text-align: center;
            color: #f5f5f5;
        }

        th {
            background-color: #2c3e50;
            color: #f5c776;
        }

        td {
            background-color: #121e2a;
        }

        tr:nth-child(even) td {
            background-color: #2c3e50;
        }

        tr:hover {
            background-color: #f5c776;
            color: #1d2a35;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .no-data {
            font-style: italic;
            color: #aaa;
            text-align: center;
        }

        .footer {
            text-align: center;
            margin-top: 50px;
        }

        .footer a {
            color: #f5c776;
            font-size: 1rem;
            text-decoration: none;
        }

        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h2>Available Books</h2>

<div class="filter-form">
    <form method="get" action="">
        <label for="title">Title:</label>
        <input type="text" name="title" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>" />

        <label for="author">Author:</label>
        <input type="text" name="author" value="<%= request.getParameter("author") != null ? request.getParameter("author") : "" %>" />

        <label for="category">Category:</label>
        <select id="category" name="category">
            <option value="">All Categories</option>
            <%
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    conn = DBConnections.getConnection();
                    String sql = "SELECT DISTINCT Category FROM Books WHERE Category IS NOT NULL AND Category != '' ORDER BY Category ASC";
                    stmt = conn.prepareStatement(sql);
                    rs = stmt.executeQuery();

                    String selectedCategory = request.getParameter("category");

                    while (rs.next()) {
                        String category = rs.getString("Category");
                        boolean isSelected = selectedCategory != null && selectedCategory.equals(category);
            %>
                        <option value="<%= category %>" <%= isSelected ? "selected" : "" %>><%= category %></option>
            <%
                    }
                } catch (Exception e) {
                    // Silent fail or log error if needed
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception ignored) {}
                    try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
                    try { if (conn != null) conn.close(); } catch (Exception ignored) {}
                }
            %>
        </select>

        <button type="submit">Filter</button>
        <button type="button" onclick="exportToPDF()" style="
            background-color: #2c3e50;
            color: #f5c776;
            margin-left: 10px;">Export as PDF</button>
    </form>
</div>

<div class="table-container">
    <table id="availableBooksTable">
        <thead>
            <tr>
                <th>Book ID</th>
                <th>Title</th>
                <th>Author</th>
                <th>Category</th>
            </tr>
        </thead>
        <tbody>
        <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet result = null;

            String titleFilter = request.getParameter("title");
            String authorFilter = request.getParameter("author");
            String categoryFilter = request.getParameter("category");

            try {
                con = DBConnections.getConnection();

                StringBuilder query = new StringBuilder("SELECT * FROM Books WHERE Status = 'Available'");
                java.util.List<String> params = new java.util.ArrayList<String>();

                if (titleFilter != null && !titleFilter.trim().isEmpty()) {
                    query.append(" AND Title LIKE ?");
                    params.add("%" + titleFilter + "%");
                }

                if (authorFilter != null && !authorFilter.trim().isEmpty()) {
                    query.append(" AND Author LIKE ?");
                    params.add("%" + authorFilter + "%");
                }

                if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                    query.append(" AND Category = ?");
                    params.add(categoryFilter);
                }

                ps = con.prepareStatement(query.toString());

                int index = 1;
                for (String param : params) {
                    ps.setString(index++, param);
                }

                result = ps.executeQuery();

                boolean found = false;
                while (result.next()) {
                    found = true;
        %>
            <tr>
                <td><%= result.getInt("BookID") %></td>
                <td><%= result.getString("Title") %></td>
                <td><%= result.getString("Author") %></td>
                <td><%= result.getString("Category") %></td>
            </tr>
        <%
                }
                if (!found) {
        %>
            <tr>
                <td colspan="4" class="no-data">No available books found with the selected filters.</td>
            </tr>
        <%
                }
            } catch (Exception e) {
        %>
            <tr>
                <td colspan="4" class="no-data">Error: <%= e.getMessage() %></td>
            </tr>
        <%
            } finally {
                try { if (result != null) result.close(); } catch (Exception ignored) {}
                try { if (ps != null) ps.close(); } catch (Exception ignored) {}
                try { if (con != null) con.close(); } catch (Exception ignored) {}
            }
        %>
        </tbody>
    </table>
</div>

<div class="footer">
    <p><a href="dashboard.jsp">Back to Dashboard</a></p>
</div>

<!-- jsPDF Library -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js "></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.23/jspdf.plugin.autotable.min.js "></script>

<script>
    function exportToPDF() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF("portrait", "pt", "a4");

        const table = document.getElementById("availableBooksTable");

        // Collect headers
        const headerRow = [];
        const headers = table.querySelectorAll("thead th");
        headers.forEach(th => headerRow.push(th.innerText));

        // Collect visible rows only
        const dataRows = [];
        const rows = table.querySelectorAll("tbody tr");

        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            if (row.style.display === "none") continue;

            const cols = row.getElementsByTagName("td");
            const rowData = [];
            for (let j = 0; j < cols.length; j++) {
                rowData.push(cols[j].innerText);
            }
            dataRows.push(rowData);
        }

        doc.setFontSize(16);
        doc.text("Available Books Report", 40, 40);
        doc.setFontSize(10);
        doc.text("Generated on: " + new Date().toLocaleString(), 40, 60);

        doc.autoTable({
            head: [headerRow],
            body: dataRows,
            startY: 80,
            theme: 'grid',
            styles: { fillColor: '#121e2a', textColor: '#f5f5f5' },
            headStyles: { fillColor: '#2c3e50', textColor: '#f5c776' }
        });

        doc.save("Available_Books_Report.pdf");
    }
</script>

</body>
</html>