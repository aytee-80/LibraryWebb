<%@ page import="java.sql.*" %>
<%@ page import="DBConnections.DBConnections" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Library Charts</title>
    <style>
        body {
            background-color: #1d2a35;
            color: #f5f5f5;
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 40px;
        }

        h2 {
            margin-bottom: 30px;
        }

        canvas {
            max-width: 800px;
            margin: auto;
        }

        .footer {
            margin-top: 60px;
        }

        .footer a {
            color: #f5c776;
            text-decoration: none;
        }

        .footer a:hover {
            text-decoration: underline;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js "></script>
</head>
<body>

<h2>Library Summary Chart</h2>

<%
    int totalMembers = 0;
    int totalBooks = 0;
    int totalBorrowed = 0;
    int totalReserved = 0;
    int totalAvailable = 0;

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnections.getConnection();
        stmt = conn.createStatement();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM Users");
        if (rs.next()) totalMembers = rs.getInt(1);

        rs = stmt.executeQuery("SELECT COUNT(*) FROM Books");
        if (rs.next()) totalBooks = rs.getInt(1);

        rs = stmt.executeQuery("SELECT COUNT(*) FROM Books WHERE Status = 'Borrowed'");
        if (rs.next()) totalBorrowed = rs.getInt(1);

        rs = stmt.executeQuery("SELECT COUNT(*) FROM Books WHERE Status = 'Reserved'");
        if (rs.next()) totalReserved = rs.getInt(1);

        rs = stmt.executeQuery("SELECT COUNT(*) FROM Books WHERE Status = 'Available'");
        if (rs.next()) totalAvailable = rs.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>

<canvas id="libraryChart" height="700" width = "1000"></canvas>

<div class="footer">
    <p><a href="dashboard.jsp">Back to Dashboard</a></p>
</div>

<script>
    const ctx = document.getElementById('libraryChart').getContext('2d');

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Members', 'Books', 'Borrowed', 'Reserved', 'Available'],
            datasets: [{
                label: 'Count',
                data: [
                    <%= totalMembers %>,
                    <%= totalBooks %>,
                    <%= totalBorrowed %>,
                    <%= totalReserved %>,
                    <%= totalAvailable %>
                ],
                backgroundColor: '#f5c776',
                borderColor: '#f5c776',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.raw + " items";
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                       ticks: {
                color: '#f5f5f5',
                stepSize: 10,     // Optional: improve tick spacing
                maxTicksLimit: 10  // Show more ticks if needed
            },
                    grid: { color: '#444' }
                },
                x: {
                    ticks: { color: '#f5f5f5' },
                    grid: { color: '#444' }
                }
            }
        }
    });
</script>

</body>
</html>