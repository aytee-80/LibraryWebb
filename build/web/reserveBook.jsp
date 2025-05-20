<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="javax.servlet.http.HttpSession" %>
<%
    String email = (String) session.getAttribute("username");
    String bookId = request.getParameter("bookId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Reserve Book</title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700&family=Open+Sans&display=swap');

        body {
            font-family: 'Open Sans', sans-serif;
            background-color: #1d2a35;
            color: #f5f5f5;
            margin: 0;
            padding: 0;
            padding-top: 80px;
        }

        h2 {
            font-family: 'Merriweather', serif;
            text-align: center;
            color: #f5c776;
            margin-top: 40px;
            margin-bottom: 20px;
            font-size: 2rem;
        }

        form {
            max-width: 600px;
            margin: auto;
            background-color: #121e2a;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
        }

        label {
            display: block;
            font-size: 1.1rem;
            color: #f5f5f5;
            margin-bottom: 6px;
        }

        input[type="date"] {
            width: 100%;
            padding: 10px;
            font-size: 1rem;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f5f5f5;
            color: #333;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px;
            font-size: 1.2rem;
            background-color: #f5c776;
            color: #1d2a35;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #ffdb70;
        }

        .error {
            color: red;
            font-size: 0.9rem;
        }
    </style>

    <script>
        function validateForm() {
            // Validate reservation date (must not be before today)
            var reservationDate = new Date(document.forms["reserveForm"]["reservationDate"].value);
            var today = new Date();

            if (reservationDate < today) {
                document.getElementById("dateError").innerText = "Reservation date cannot be before today.";
                return false;
            } else {
                document.getElementById("dateError").innerText = "";
            }

            return true;
        }
    </script>
</head>
<body>

    <h2>Reserve Book</h2>
    <form name="reserveForm" action="BookActionServlet.do" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="action" value="reserve">
        <input type="hidden" name="bookId" value="<%= bookId %>">
        <input type="hidden" name="email" value="<%= email %>">

        <label>Reservation Date:</label><br>
        <input type="date" name="reservationDate" required><br>
        <div id="dateError" class="error"></div><br>

        <input type="submit" value="Confirm Reservation">
    </form>
</body>
</html>
