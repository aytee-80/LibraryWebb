<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="DBConnections.DBConnections" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Summary Report</title>
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
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 30px;
        }

        .filters select, .filters button {
            padding: 10px 20px;
            background-color: #121e2a;
            color: #f5f5f5;
            border: 1px solid #555;
            border-radius: 5px;
            font-size: 14px;
        }

        .filters button {
            background-color: #f5c776;
            color: #1d2a35;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }

        .summary-container {
            display: flex;
            justify-content: center;
            gap: 30px;
            flex-wrap: wrap;
            margin-top: 30px;
        }

        .card {
            background: #121e2a;
            padding: 20px;
            width: 200px;
            text-align: center;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .card h3 {
            font-size: 2.5em;
            color: #f5c776;
        }

        .card span {
            font-size: 1em;
            color: #aaa;
            display: block;
            margin-top: 10px;
        }

        .card:hover {
            background-color: #2c3e50;
            transition: background-color 0.3s ease;
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

<h2>Library Summary Report</h2>

<div class="filters">
    <select id="summaryFilter" onchange="filterCards()">
        <option value="all">All</option>
        <option value="members">Members</option>
        <option value="books">Books</option>
        <option value="borrowed">Borrowed</option>
        <option value="reserved">Reserved</option>
        <option value="available">Available</option>
    </select>

    <button onclick="exportToPDF()">Export as PDF</button>
    <button onclick= "window.location.href='charts.jsp'">Open Chart</button>
</div>

<div class="summary-container" id="summaryCards">
    <%
        Connection con = null;
        Statement stmt = null;
        ResultSet rsMembers = null;
        ResultSet rsBooks = null;
        ResultSet rsReserved = null;
        ResultSet rsBorrowed = null;
        ResultSet rsAvailable = null;

        try {
            con = DBConnections.getConnection();
            stmt = con.createStatement();

            rsMembers = stmt.executeQuery("SELECT COUNT(*) FROM Users");
            rsMembers.next();
            int totalMembers = rsMembers.getInt(1);

            rsBooks = stmt.executeQuery("SELECT COUNT(*) FROM Books");
            rsBooks.next();
            int totalBooks = rsBooks.getInt(1);

            rsReserved = stmt.executeQuery("SELECT COUNT(*) FROM Books WHERE Status = 'Reserved'");
            rsReserved.next();
            int totalReserved = rsReserved.getInt(1);

            rsBorrowed = stmt.executeQuery("SELECT COUNT(*) FROM Books WHERE Status = 'Borrowed'");
            rsBorrowed.next();
            int totalBorrowed = rsBorrowed.getInt(1);

            rsAvailable = stmt.executeQuery("SELECT COUNT(*) FROM Books WHERE Status = 'Available'");
            rsAvailable.next();
            int totalAvailable = rsAvailable.getInt(1);
    %>
            <div class="card" data-category="members">
                <h3><%= totalMembers %></h3>
                <span>Total Members</span>
            </div>
            <div class="card" data-category="books">
                <h3><%= totalBooks %></h3>
                <span>Total Books</span>
            </div>
            <div class="card" data-category="reserved">
                <h3><%= totalReserved %></h3>
                <span>Total Reserved</span>
            </div>
            <div class="card" data-category="borrowed">
                <h3><%= totalBorrowed %></h3>
                <span>Total Borrowed</span>
            </div>
            <div class="card" data-category="available">
                <h3><%= totalAvailable %></h3>
                <span>Total Available</span>
            </div>
    <%
        } catch (Exception e) {
            out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
        } finally {
            try { if (rsMembers != null) rsMembers.close(); } catch (Exception ignored) {}
            try { if (rsBooks != null) rsBooks.close(); } catch (Exception ignored) {}
            try { if (rsReserved != null) rsReserved.close(); } catch (Exception ignored) {}
            try { if (rsBorrowed != null) rsBorrowed.close(); } catch (Exception ignored) {}
            try { if (rsAvailable != null) rsAvailable.close(); } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    %>
</div>

<div class="footer">
    <p><a href="dashboard.jsp">Back to Dashboard</a></p>
</div>

<!-- jsPDF Library -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js "></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.23/jspdf.plugin.autotable.min.js "></script>

<script>
    function filterCards() {
        const selected = document.getElementById("summaryFilter").value.toLowerCase();
        const cards = document.querySelectorAll(".card");

        cards.forEach(card => {
            const category = card.getAttribute("data-category").toLowerCase();
            if (selected === "all" || category.includes(selected)) {
                card.style.display = "";
            } else {
                card.style.display = "none";
            }
        });
    }

    function exportToPDF() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF("portrait", "pt", "a4");

        // Title
        doc.setFontSize(18);
        doc.text("Library Summary Report", 40, 40);
        doc.setFontSize(10);
        doc.text("Generated on: " + new Date().toLocaleString(), 40, 60);

        // Collect visible cards
        const summaryData = [];
        const cards = document.querySelectorAll(".card");

        cards.forEach(card => {
            if (card.style.display !== "none") {
                const label = card.querySelector("span").innerText;
                const value = card.querySelector("h3").innerText;
                summaryData.push([label, value]);
            }
        });

        // Generate PDF Table
        doc.autoTable({
            head: [["Metric", "Value"]],
            body: summaryData,
            startY: 80,
            theme: 'grid',
            styles: { fillColor: '#121e2a', textColor: '#f5f5f5' },
            headStyles: { fillColor: '#2c3e50', textColor: '#f5c776' }
        });

        doc.save("Library_Summary_Report.pdf");
    }
</script>

</body>
</html>