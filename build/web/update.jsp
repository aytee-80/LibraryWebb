<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Book</title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700&family=Open+Sans&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Open Sans', sans-serif;
            background-color: #1d2a35;
            color: #f5f5f5;
            line-height: 1.6;
            padding-top: 100px;
        }

        h1 {
            text-align: center;
            color: #f5c776;
            font-size: 2rem;
            margin-bottom: 30px;
            font-family: 'Merriweather', serif;
        }

        form {
            background-color: #121e2a;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            max-width: 400px;
            margin: 0 auto;
        }

        label {
            font-size: 1.1rem;
            margin-bottom: 10px;
            display: block;
            color: #f5f5f5;
        }

        input[type="text"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1rem;
            background-color: #f5f5f5;
            color: #333;
        }

        .error {
            color: red;
            font-size: 0.9rem;
            display: none;
            margin-bottom: 10px;
        }

        input[type="submit"] {
            background-color: #f5c776;
            color: #1d2a35;
            border: none;
            padding: 12px;
            font-size: 1.1rem;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            width: 100%;
        }

        input[type="submit"]:hover {
            background-color: #ffdb70;
        }

        a {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #f5c776;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>

    <script>
        function validateForm() {
            const id = document.getElementById("id").value.trim();
            const error = document.getElementById("idError");

            if (!/^\d+$/.test(id)) {
                error.style.display = "block";
                return false;
            }

            error.style.display = "none";
            return true;
        }
    </script>
</head>
<body>
    <h1>Update Book</h1>

    <form action="updateBookForm.jsp" method="post" onsubmit="return validateForm()">
        <label for="id">Book ID:</label>
        <input type="text" id="id" name="id" required>
        <div class="error" id="idError">Book ID must contain only numbers.</div>

        <input type="submit" value="Update">
    </form>

    <a href="dashboard.jsp">Back to Dashboard</a>
</body>
</html>
