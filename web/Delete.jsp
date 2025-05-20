<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Book</title>
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

        h1 {
            font-family: 'Merriweather', serif;
            text-align: center;
            color: #f5c776;
            margin-top: 40px;
            margin-bottom: 20px;
            font-size: 2rem;
        }

        form {
            background-color: #121e2a;
            max-width: 500px;
            margin: auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
        }

        label {
            display: block;
            font-size: 1.1rem;
            color: #f5f5f5;
            margin-bottom: 8px;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 20px;
            background-color: #f5f5f5;
            color: #333;
        }

        input[type="submit"] {
            background-color: #e53935;
            color: white;
            padding: 12px;
            font-size: 1.1rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
            width: 100%;
        }

        input[type="submit"]:hover {
            background-color: #c62828;
        }

        .error-message {
            color: #e74c3c;
            text-align: center;
            margin-top: 20px;
            font-weight: bold;
        }

        /* Styled Link */
       
       

        a:focus {
            outline: none;
            box-shadow: 0 0 5px 2px rgba(245, 199, 118, 0.7);
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

        @media (max-width: 600px) {
            form {
                margin: 20px;
                padding: 20px;
            }

            h1 {
                font-size: 1.5rem;
            }
        }
    </style>

    <script>
        function validateForm() {
            var bookId = document.getElementById('id').value;
            var errorMessage = document.getElementById('error-message');

            // Check if the book ID is a valid number
            if (isNaN(bookId) || bookId.trim() === "") {
                errorMessage.textContent = "Please enter a valid numeric Book ID.";
                return false; // Prevent form submission
            }

            errorMessage.textContent = ""; // Clear any previous error messages
            return true; // Allow form submission
        }
    </script>
</head>
<body>

    <h1>Delete Book</h1>

    <form action="DeleteBookServlet.do" method="post" onsubmit="return validateForm()">
        <label for="id">Book ID:</label>
        <input type="text" id="id" name="id" required>
        <div id="error-message" class="error-message"></div>

        <input type="submit" value="Delete">
    </form>

  <div class="footer">
    <p><a href="dashboard.jsp">Back to DashBoard</a></p>
</div>
</body>
</html>
