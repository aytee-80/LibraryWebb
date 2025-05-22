<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="DBConnections.DBConnections" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reserved Books Report</title>
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
            width: 90%;
            margin: 0 auto 30px auto;
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .filters input, .filters button {
            padding: 10px;
            border: 1px solid #555;
            background-color: #121e2a;
            color: #f5f5f5;
            border-radius: 5px;
            min-width: 180px;
            font-size: 14px;
        }

        .filters button {
            background-color: #f5c776;
            color: #1d2a35;
            font-weight: bold;
            cursor: pointer;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 90%;
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

        tr:nth-child(even) {
            background-color: #2c3e50;
        }

        tr:hover {
            background-color: #f5c776;
            color: #1d2a35;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .message-row {
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

<h2>Reserved Books Report</h2>

<div class="filters">
    <input type="text" id="searchInput" placeholder="Search by Title or Email...">
    <input type="date" id="fromDate" title="From Date">
    <input type="date" id="toDate" title="To Date">
    <button onclick="filterTable()">Filter</button>
    <button onclick="exportToPDF()" style="margin-left: 10px;">Export as PDF</button>
</div>

<div class="table-container">
    <table id="reservedTable">
        <thead>
            <tr>
                <th>Title</th>
                <th>Reserved By</th>
                <th>Email</th>
                <th>Reservation Date</th>
            </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DBConnections.getConnection();
                String sql = "SELECT b.Title, u.Name, u.Email, rb.ReservationDate "
                           + "FROM ReservedBooks rb "
                           + "JOIN Books b ON rb.BookID = b.BookID "
                           + "JOIN Users2 u ON rb.UserEmail = u.Email";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                boolean found = false;
                while (rs.next()) {
                    found = true;
        %>
            <tr>
                <td><%= rs.getString("Title") %></td>
                <td><%= rs.getString("Name") %></td>
                <td><%= rs.getString("Email") %></td>
                <td><%= rs.getDate("ReservationDate") %></td>
            </tr>
        <%
                }
                if (!found) {
        %>
            <tr>
                <td colspan="4" class="message-row">No reserved books found.</td>
            </tr>
        <%
                }
            } catch (Exception e) {
        %>
            <tr>
                <td colspan="4" class="message-row">Error: <%= e.getMessage() %></td>
            </tr>
        <%
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

<!-- Include jsPDF for PDF export -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js "></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.23/jspdf.plugin.autotable.min.js "></script>

<script>
    function filterTable() {
        const input = document.getElementById("searchInput").value.toLowerCase();
        const fromDate = document.getElementById("fromDate").value;
        const toDate = document.getElementById("toDate").value;

        const rows = document.getElementById("reservedTable").getElementsByTagName("tr");

        for (let i = 1; i < rows.length; i++) {
            const cells = rows[i].getElementsByTagName("td");
            if (!cells.length) continue;

            const title = cells[0].innerText.toLowerCase();
            const email = cells[2].innerText.toLowerCase();
            const reservationDate = cells[3].innerText;

            const textMatch = title.includes(input) || email.includes(input);

            let dateMatch = true;
            if (fromDate) dateMatch = dateMatch && (reservationDate >= fromDate);
            if (toDate) dateMatch = dateMatch && (reservationDate <= toDate);

            rows[i].style.display = (textMatch && dateMatch) ? "" : "none";
        }
    }

    function exportToPDF() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF("portrait", "pt", "a4");

        const table = document.getElementById("reservedTable");

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
        doc.text("Reserved Books Report", 40, 40);
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

        doc.save("Reserved_Books_Report.pdf");
    }
</script>

</body>
</html>