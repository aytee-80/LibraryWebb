<%@page import="java.sql.*"%>
<%@page import="DBConnections.DBConnections"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Books Report</title>
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

        .filters {
            width: 80%;
            margin: 0 auto 30px auto;
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 10px;
        }

        .filters input,
        .filters select,
        .filters button {
            padding: 10px;
            border: 1px solid #555;
            background-color: #121e2a;
            color: #f5f5f5;
            border-radius: 5px;
            min-width: 180px;
            font-size: 14px;
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

<h2>Books Report</h2>

<div class="filters">
    <input type="text" id="reportSearch" onkeyup="filterReport()" placeholder="Search category or number...">
    
    <select id="categoryFilter" onchange="filterReport()">
        <option value="">All Categories</option>
        <option value="Fiction">Fiction</option>
        <option value="Non-fiction">Non-fiction</option>
        <option value="Science">Science</option>
        <option value="History">History</option>
    </select>

    <select id="numberFilter" onchange="filterReport()">
        <option value="">All Counts</option>
        <option value="1-10">1 - 10</option>
        <option value="11-50">11 - 50</option>
        <option value="51-100">51 - 100</option>
        <option value="101-1000">101+</option>
    </select>

    <button onclick="exportToPDF()" style="
        background-color: #2c3e50;
        color: #f5c776;
        padding: 10px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        margin-left: 10px;
    ">Export as PDF</button>
</div>

<div class="table-container">
    <table id="reportTable">
        <thead>
            <tr>
                <th>#</th>
                <th>Category</th>
                <th>Total Books</th>
            </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DBConnections.getConnection();
                String sql = "SELECT Category, COUNT(*) AS TotalBooks FROM Books GROUP BY Category";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                int count = 1;
                while (rs.next()) {
        %>
            <tr>
                <td><%= count++ %></td>
                <td><%= rs.getString("Category") %></td>
                <td><%= rs.getInt("TotalBooks") %></td>
            </tr>
        <%
                }
            } catch (Exception e) {
        %>
            <tr><td colspan="3" class="no-data">Error: <%= e.getMessage() %></td></tr>
        <%
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception ignored) {}
                try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
                try { if (conn != null) conn.close(); } catch (Exception ignored) {}
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
    function filterReport() {
        const search = document.getElementById("reportSearch").value.toLowerCase();
        const category = document.getElementById("categoryFilter").value.toLowerCase();
        const numberRange = document.getElementById("numberFilter").value;
        const rows = document.querySelectorAll("#reportTable tbody tr");

        rows.forEach(row => {
            const cells = row.getElementsByTagName("td");
            if (!cells.length) return;

            const catText = cells[1].innerText.toLowerCase();
            const num = parseInt(cells[2].innerText);

            let matchSearch = catText.includes(search) || cells[2].innerText.includes(search);
            let matchCategory = category === "" || catText === category;
            let matchNumber = true;

            if (numberRange !== "") {
                const [min, max] = numberRange.split("-").map(Number);
                if (max) {
                    matchNumber = num >= min && num <= max;
                } else {
                    matchNumber = num >= min;
                }
            }

            row.style.display = matchSearch && matchCategory && matchNumber ? "" : "none";
        });
    }

    function exportToPDF() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF("portrait", "pt", "a4");

        const table = document.getElementById("reportTable");

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
        doc.text("Book Category Report", 40, 40);
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

        doc.save("Book_Category_Report.pdf");
    }
</script>

</body>
</html>